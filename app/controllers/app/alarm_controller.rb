module App
    class AlarmController < ApplicationController

        # @Get http://localhost:3000/app/alarm
        # 키워드 알림 게시글 전체 조회 API

        def index
            alarms = Alarm.select('
            alarms.alarmId, 
            CONCAT("[", keywords.keyword, " 키워드 알림] ", title) AS title, 
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
            .where('alarms.userId = 1')
            .order('alarms.createAt DESC')

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