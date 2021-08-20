module App
    class PostController < ApplicationController

        def index
            postInfo = Post.all()

            # 출력하는 방법
            # Rails.logger.debug "postInfo: #{postInfo[0].postId}"

            render json: { 
                isSuccess:true, 
                code:1000, 
                message:"글 전체조회 완료", 
                result: postInfo }, status: :ok
        end


        # @Post http://localhost:3000/app/post
        # 게시글 작성 API + 키워드 게시글 알림 생성 API
        def create
            post = Post.new(post_params)

            if post.save
                # Rails.logger.debug "PostParams: #{post.postId}"

                # 게시글 생성 시 => 해당 게시글에 내 키워드가 있는지 확인
                keywordInfo = Post.select("keywordId")
                .joins("CROSS JOIN keywords")
                .where("status = 'Y'
                AND title REGEXP keyword
                AND postId = #{post.postId}")

                Rails.logger.debug "KeywordInfo: #{keywordInfo}"
                
                Rails.logger.debug "TrueOrFalse: #{keywordInfo.present?}"
                
                # 내 키워드가 있을 경우
                if keywordInfo.present?

                    # post.postId, keywordInfo.keywordId 를 Alarm 모델에 저장
                    alarm = Alarm.new()
                    alarm.postId = post.postId
                    alarm.keywordId = keywordInfo.keywordId

                    if alarm.save!
                        render json: { 
                            isSuccess:false, 
                            code:3002, 
                            message:"알림 생성 실패", 
                            result: alarm.errors }, status: :unprocessable_entity
                    end
                        
                end

                
                render json: { 
                    isSuccess:true, 
                    code:1000, 
                    message:"게시글 작성 완료", 
                    result: post }, status: :ok

 
            else
                render json: { 
                    isSuccess:false, 
                    code:3000, 
                    message:"게시글 작성 실패", 
                    result: post.errors }, status: :unprocessable_entity
            end
        end


        private
        def post_params
            params.permit(:title, :content, :imageUrl)
        end



    end
end