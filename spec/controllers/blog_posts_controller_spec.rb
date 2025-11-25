require 'rails_helper'

RSpec.describe BlogPostsController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all blog posts' do
      blog_post1 = create(:blog_post)
      blog_post2 = create(:blog_post, title: 'Another Post')
      get :index
      expect(assigns(:blog_posts)).to match_array([blog_post1, blog_post2])
    end
  end

  describe 'GET #show' do
    let(:blog_post) { create(:blog_post) }

    it 'returns a successful response' do
      get :show, params: { id: blog_post.id }
      expect(response).to be_successful
    end

    it 'assigns the requested blog post' do
      get :show, params: { id: blog_post.id }
      expect(assigns(:blog_post)).to eq(blog_post)
    end

    it 'redirects to root path when blog post is not found' do
      get :show, params: { id: 999 }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new blog post' do
      get :new
      expect(assigns(:blog_post)).to be_a_new(BlogPost)
    end
  end

  describe 'GET #edit' do
    let(:blog_post) { create(:blog_post) }

    it 'returns a successful response' do
      get :edit, params: { id: blog_post.id }
      expect(response).to be_successful
    end

    it 'assigns the requested blog post' do
      get :edit, params: { id: blog_post.id }
      expect(assigns(:blog_post)).to eq(blog_post)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { blog_post: { title: 'New Post', body: 'Post content' } } }

      it 'creates a new blog post' do
        expect {
          post :create, params: valid_params
        }.to change(BlogPost, :count).by(1)
      end

      it 'redirects to the created blog post' do
        post :create, params: valid_params
        expect(response).to redirect_to(BlogPost.last)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { blog_post: { title: '', body: '' } } }

      it 'does not create a new blog post' do
        expect {
          post :create, params: invalid_params
        }.not_to change(BlogPost, :count)
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:blog_post) { create(:blog_post) }

    context 'with valid parameters' do
      let(:new_attributes) { { title: 'Updated Title', body: 'Updated body' } }

      it 'updates the blog post' do
        patch :update, params: { id: blog_post.id, blog_post: new_attributes }
        blog_post.reload
        expect(blog_post.title).to eq('Updated Title')
        expect(blog_post.body).to eq('Updated body')
      end

      it 'redirects to the blog post' do
        patch :update, params: { id: blog_post.id, blog_post: new_attributes }
        expect(response).to redirect_to(blog_post)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: '', body: '' } }

      it 'does not update the blog post' do
        original_title = blog_post.title
        patch :update, params: { id: blog_post.id, blog_post: invalid_attributes }
        blog_post.reload
        expect(blog_post.title).to eq(original_title)
      end

      it 'renders the edit template' do
        patch :update, params: { id: blog_post.id, blog_post: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:blog_post) { create(:blog_post) }

    it 'destroys the blog post' do
      expect {
        delete :destroy, params: { id: blog_post.id }
      }.to change(BlogPost, :count).by(-1)
    end

    it 'redirects to root path' do
      delete :destroy, params: { id: blog_post.id }
      expect(response).to redirect_to(root_path)
    end
  end
end
