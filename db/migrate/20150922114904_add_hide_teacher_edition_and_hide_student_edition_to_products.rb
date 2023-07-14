class AddHideTeacherEditionAndHideStudentEditionToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :hide_teacher_edition, :boolean, default: false
    add_column :products, :hide_student_edition, :boolean, default: false
  end
end
