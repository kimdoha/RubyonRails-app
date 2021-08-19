module App
    class PostController < ApplicationController
        def index
            postInfo = Post.all()
            render json: { isSuccess:true, code:1000, message:"글 전체조회 완료", result: postInfo }, status: :ok
        end

        def create
            post = Post.new(post_params)

            if post.save
                render json: { isSuccess:true, code:1000, message:"게시글 작성 완료", result: post }, status: :ok
            else
                render json: { isSuccess:false, code:3000, message:"게시글 작성 실패", result: post.errors }, 
                status: :unprocessable_entity
            end
        end

        private
        def post_params
            params.permit(:title, :content)
        end
    end
end