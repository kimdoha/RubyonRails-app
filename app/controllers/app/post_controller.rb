module App
    class PostController < ApplicationController

        # SuckerPunch => Job 모듈을 가져옵니다.
        include SuckerPunch::Job 

        def index
            postInfo = Post.all()
            .where("status = 'Y'")


            render json: { 
                isSuccess:true, 
                code:1000, 
                message:"글 전체조회 완료", 
                result: postInfo }, status: :ok
        end


        # @Post http://localhost:3000/app/post
        # 게시글 작성 API + [키워드 알림] 게시글 생성 API 
        # (+FCM 알림 | 비동기 방식)

        def create
            ActiveRecord::Base.connection_pool.with_connection do

                post = Post.new(post_params)
                respond_to do |format|
                    if post.save
    
                        # [MySetting] 내 알람 유무 설정 확인하기 
                        # ON : 키워드 알림
                        # OFF : 키워드 알림 생략
                        mySetting = User.select("alarm")
                        .where("status = 'Y'
                        AND id = 1")
        
        
                        
                        # 알림ON : 설정했을 때 
                        if mySetting[0].alarm == 1
                        
                            # 게시글 생성 시 => 해당 게시글에 [내 키워드] 가 있는지 확인
                            keywordInfo = Post.select("keywords.id")
                            .joins("CROSS JOIN keywords")
                            .where("status = 'Y'
                            AND title REGEXP keyword
                            AND keywords.user_id = 1
                            AND posts.id = #{post.id}")
        
        
                            # 게시글에 [내 키워드] 가 있을 경우, [키워드 알림] 화면에 게시글 알림
                            if keywordInfo.present?
        
                                # post.postId, keywordInfo[0].keywordId 를 Alarm 모델에 저장
                                alarm = Alarm.new()
                                alarm.post_id = post.id
                                alarm.keyword_id = keywordInfo[0].id
        
                                
                                if !alarm.save
                                    render json: { 
                                        isSuccess:false, 
                                        code:3002, 
                                        message:"알림 생성 실패", 
                                        result: alarm.errors }, status: :unprocessable_entity
                                end
        
        
                                pushAlarms = Post.select('
                                CONCAT("[", keyword, " 키워드 알림] ") AS title, 
                                title AS content,
                                image_url')
                                .joins(:alarms)
                                .joins(:keywords)
                                .where('alarms.user_id = 1')
                                .order('alarms.create_at DESC')
                                .limit(1)
            
            
                                # FCM 푸시 알림 서비스 연동
                                require 'fcm'
                                fcm_client = FCM.new(FCM_SERVER_KEY) # set your FCM_SERVER_KEY
        
                                options = { priority: 'high',
                                            notification: { body: pushAlarms[0].content,       # 푸시알림 본문
                                                            title: pushAlarms[0].title,        # 푸시알림 제목
                                                            sound: 'default',                  # 푸시알림 소리
                                                            icon: pushAlarms[0].image_url       # 푸시알림 시 이미지
                                                        }
                                        }
                                
            
                                # 휴대폰 기기 토큰 값
                                registration_id = REGISTRATION_TOKEN
                            
            
                                response = fcm_client.send(registration_id, options)
                                puts response
                                    
                            end
        
                        end

                    
                        
                    format.json { render json: 
                        {
                            isSuccess:true, 
                            code:1000, 
                            message:"게시글 작성 완료", 
                            result: post 
                        }, status: :ok
                    }
     
                else
                    format.json { render json: 
                        {
                            isSuccess:false, 
                            code:3000, 
                            message:"게시글 작성 실패", 
                            result: post.errors
                        } , status: :unprocessable_entity
                    }
                end
            end
        end
    end
           
        private
        def post_params
            params.permit(:title, :content, :image_url)
        end



    end
end