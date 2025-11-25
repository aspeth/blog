require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  describe 'validations' do
    it 'is valid with a title and body' do
      blog_post = build(:blog_post)
      expect(blog_post).to be_valid
    end

    it 'is invalid without a title' do
      blog_post = build(:blog_post, title: nil)
      expect(blog_post).not_to be_valid
      expect(blog_post.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a body' do
      blog_post = build(:blog_post, body: nil)
      expect(blog_post).not_to be_valid
      expect(blog_post.errors[:body]).to include("can't be blank")
    end
  end

  describe 'creation' do
    it 'creates a blog post with valid attributes' do
      expect {
        create(:blog_post, title: 'Test Post', body: 'Test body content')
      }.to change(BlogPost, :count).by(1)
    end

    it 'sets timestamps on creation' do
      blog_post = create(:blog_post)
      expect(blog_post.created_at).to be_present
      expect(blog_post.updated_at).to be_present
    end
  end
end
