class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end


  # 入力内容を保存します。
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to root_path, notice: "送信完了"
    else
      render 'new'
    end
  end


  private

  def contact_params
    params.require(:contact).permit(:email, :name, :phone_number, :subject, :message)
  end

end
