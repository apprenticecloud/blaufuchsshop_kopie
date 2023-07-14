class AdminMailer < ApplicationMailer

  def export_user(user_email, file_info_pdf, file_info_csv)
    add_attachment(file_info_pdf)
    add_attachment(file_info_csv)

    mail(
      from: 'shop@blaufuchs-verlag.de',
      to: user_email,
      subject: "Auftrag Exportieren"
    )
  end

  def site_admin(file_info_pdf, file_info_csv)
    add_attachment(file_info_pdf)
    add_attachment(file_info_csv)

    mail(
      from: 'shop@blaufuchs-verlag.de',
      to: 'shop@blaufuchs-verlag.de',
      subject: "Auftrag Exportieren"
    )
  end

  private

  def add_attachment(file_info)
    if file_info and file_info.has_key?(:file_name) and file_info.has_key?(:file_data)
      attachments[file_info[:file_name]] = file_info[:file_data]
    end
  end
end
