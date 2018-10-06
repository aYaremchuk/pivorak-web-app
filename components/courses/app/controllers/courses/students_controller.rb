module Courses
  class StudentsController < BaseController
    helper_method :student
    before_action :execute_create_policy

    def new
      @student = ::Courses::Student.new
      render_form
    end

    def create
      @student = Student::Create.call(student_params, current_season.id, current_user.id)
      student_creation_status = student.save
      NotifySlack::Base.new(student.id).call if student_creation_status
      react_to student_creation_status
    end

    private

    def default_redirect
      redirect_to courses_season_path(current_season)
    end

    def student
      @student ||= ::Courses::Student.find(params[:id])
    end

    def execute_create_policy
      allowed = Student::CreatePolicy.new(
        current_user.id, current_season
      ).allowed?
      return if allowed
      redirect_to courses_season_path(current_season),
        alert: t('flash.courses.students.create.fail')
    end

    def student_params
      params.require(:student).permit(:personal_info, :motivation_info, :experience_info, :devote_info)
    end
  end
end
