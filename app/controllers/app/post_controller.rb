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
        # 게시글 작성 API + 키워드 게시글 알림 생성 API (비동기 방식)
        def create
            post = Post.new(post_params)

            if post.save

                # 게시글 생성 시 => 해당 게시글에 [내 키워드] 가 있는지 확인
                keywordInfo = Post.select("keywordId")
                .joins("CROSS JOIN keywords")
                .where("status = 'Y'
                AND title REGEXP keyword
                AND postId = #{post.postId}")

                # Rails.logger.debug "KeywordInfo: #{keywordInfo[0].keywordId}"
                # Rails.logger.debug "TrueOrFalse: #{keywordInfo.present?}"
                
                # 게시글에 [내 키워드] 가 있을 경우, [키워드 알림]화면에 게시글 알림
                if keywordInfo.present?

                    # post.postId, keywordInfo.keywordId 를 Alarm 모델에 저장
                    alarm = Alarm.new()
                    alarm.postId = post.postId
                    alarm.keywordId = keywordInfo[0].keywordId

                    
                    if !alarm.save
                        render json: { 
                            isSuccess:false, 
                            code:3002, 
                            message:"알림 생성 실패", 
                            result: alarm.errors }, status: :unprocessable_entity
                    end

                    # Rails.logger.debug "AlarmInfo1: #{alarm.keywordId}"
                    # Rails.logger.debug "AlarmInfo2: #{alarm.postId}"
                        
                end

                pushAlarms = Alarm.select('
                alarms.alarmId, 
                CONCAT("[", keywords.keyword, " 키워드 알림] ") AS title, 
                posts.title AS content,
                imageUrl,
                (CASE
                    WHEN TIMESTAMPDIFF(SECOND, posts.createAt, now()) <= 0 THEN "방금 전"
                    WHEN TIMESTAMPDIFF(SECOND, posts.createAt, NOW()) < 60 THEN CONCAT(TIMESTAMPDIFF(SECOND, posts.createAt, NOW()), "초 전")
                    WHEN TIMESTAMPDIFF(MINUTE, posts.createAt, NOW()) < 60 THEN CONCAT(TIMESTAMPDIFF(MINUTE, posts.createAt, NOW()), "분 전")
                    WHEN TIMESTAMPDIFF(HOUR, posts.createAt, NOW()) < 24 THEN CONCAT(TIMESTAMPDIFF(HOUR, posts.createAt, NOW()), "시간 전")
                    WHEN TIMESTAMPDIFF(DAY, posts.createAt, NOW()) < 31 THEN CONCAT(TIMESTAMPDIFF(DAY, posts.createAt, NOW()), "일 전")
                    WHEN TIMESTAMPDIFF(MONTH, posts.createAt, NOW()) < 12 THEN CONCAT(TIMESTAMPDIFF(MONTH, posts.createAt, NOW()), "달 전")
                    ELSE CONCAT(TIMESTAMPDIFF(YEAR, posts.createAt, NOW()), "년 전")
            END) AS time')
                .joins('INNER JOIN posts ON alarms.postId = posts.postId')
                .joins('INNER JOIN keywords ON alarms.keywordId = keywords.keywordId')
                .order('alarms.createAt DESC')
                .limit(1)

                Rails.logger.debug "AlarmInfo: #{pushAlarms[0].title}"
                Rails.logger.debug "AlarmInfo: #{pushAlarms[0].content}"


                # FCM 푸시 알림 서비스 연동
                require 'fcm'
                fcm_client = FCM.new('') # set your FCM_SERVER_KEY
    
                
                options = { priority: 'high',
                            # data: { 
                            #     message: message, 
                            #     icon: image 
                            # },
                            notification: { body: pushAlarms[0].content,       # 푸시알림 본문
                                            title: pushAlarms[0].title,        # 푸시알림 제목
                                            sound: 'default',                  # 푸시알림 소리
                                            icon: pushAlarms[0].imageUrl       # 푸시알림 시 이미지
                                          }
                           }
                

                # 휴대폰 기기 토큰 값
                registration_id = ""
              

                response = fcm_client.send(registration_id, options)
                puts response

      

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