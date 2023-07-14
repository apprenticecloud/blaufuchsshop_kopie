class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.valid?
      MessageMailer.new_message(@message).deliver_now
      redirect_to contact_path, notice: "Nachricht erfolgreich abgesendet."
    else
      flash[:alert] = "Ein Fehler ist aufgetreten. Bitte füllen Sie alle Felder korrekt aus."
      render :new
    end
  end

private

  def message_params
    params.require(:message).permit(:name, :email, :content)
  end

end