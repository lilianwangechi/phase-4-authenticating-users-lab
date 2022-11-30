class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  def create
    article = Article.create(article_params)
    render json: article, status: :created
  end

  def destroy
    article = Article.find_by(id: params[:id])
    article.destroy
    head :no_content
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def article_params
    params.permit(:title, :content, :minutes_to_read)
  end

end
