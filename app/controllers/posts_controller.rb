# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  # GET /posts
  def index
    posts = Post.all.with_attached_image
    render json: posts.map { |post| post_with_image(post) }
  end

  # GET /posts/:id
  def show
    post = Post.find(params[:id])
    render json: post_with_image(post)
  end

  # POST /posts
  def create
    post = Post.new(post_params)
    if post.save
      render json: post_with_image(post), status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  # PUT /posts/:id
  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: post_with_image(post)
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    post = Post.find(params[:id])
    post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def post_with_image(post)
    post.as_json.merge({
                         image_url: post.image.attached? ? url_for(post.image) : nil
                       })
  end
end
