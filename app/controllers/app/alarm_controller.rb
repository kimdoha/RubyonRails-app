module App
    class AlarmController < ApplicationController

        # @Get http://localhost:3000/app/alarm
        # 키워드 알림 게시글 전체 조회 API

        def index

        alarms = Post.select('
        alarms.id, 
        CONCAT("[", keyword, " 키워드 알림] ", title) AS title, 
        image_url,
        (CASE
            WHEN TIMESTAMPDIFF(SECOND, posts.create_at, now()) <= 0 THEN "방금 전"
            WHEN TIMESTAMPDIFF(SECOND, posts.create_at, NOW()) < 60 THEN CONCAT(TIMESTAMPDIFF(SECOND, posts.create_at, NOW()), "초 전")
            WHEN TIMESTAMPDIFF(MINUTE, posts.create_at, NOW()) < 60 THEN CONCAT(TIMESTAMPDIFF(MINUTE, posts.create_at, NOW()), "분 전")
            WHEN TIMESTAMPDIFF(HOUR, posts.create_at, NOW()) < 24 THEN CONCAT(TIMESTAMPDIFF(HOUR, posts.create_at, NOW()), "시간 전")
            WHEN TIMESTAMPDIFF(DAY, posts.create_at, NOW()) < 31 THEN CONCAT(TIMESTAMPDIFF(DAY, posts.create_at, NOW()), "일 전")
            WHEN TIMESTAMPDIFF(MONTH, posts.create_at, NOW()) < 12 THEN CONCAT(TIMESTAMPDIFF(MONTH, posts.create_at, NOW()), "달 전")
            ELSE CONCAT(TIMESTAMPDIFF(YEAR, posts.create_at, NOW()), "년 전")
        END) AS time')
        .joins(:alarms)
        .joins(:keywords)
        .where('alarms.user_id = 1')
        .order('alarms.create_at DESC')

            # 키워드 알림 게시글이 조회될 때
            if alarms.present?
                render json: { 
                    isSuccess:true, 
                    code:1000, 
                    message:"키워드 알림 게시글 전체조회", 
                    result: alarms }, status: :ok

            # 키워드 알림 게시글이 조회되지 않을 때
            else
                render json: { 
                    isSuccess:false, 
                    code:3004, 
                    message:"키워드 알림이 없어요./n키워드를 등록하고 알림을 받아보세요.", 
                }
            end
        end



    end
end