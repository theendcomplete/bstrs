class PostMailer < ApplicationMailer


  def new_post_email
    @user = params[:user]
    @post = params[:post]
    mail(to: 'valutno@gmail.com', bcc: 'nikkie@nikkie.ru', subject: "#{@user} разместил новый пост!")
  end
end
