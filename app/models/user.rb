class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_admin?
    is_admin
  end

  def is_subscriber?
    is_subscriber
  end

  after_save :subscribe_user_to_mailing_list

  private

  def subscribe_user_to_mailing_list
    if is_subscriber?
      SubscribeUserToMailingListJob.perform_later(self)
    end
  end
end
