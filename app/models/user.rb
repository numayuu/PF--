class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :profile

  #バリデーション
  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }


  #いいね機能
  has_many :favorites, dependent: :destroy
  has_many :favarited_posts, through: :favorites, source: :post

  #コメント機能
  has_many :post_comments, dependent: :destroy

  # 検索機能（ユーザネーム）
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
end
