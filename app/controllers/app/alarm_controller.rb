module App
    class AlarmController < ApplicationController

        def index
            alarms = Alarm.order("createAt DESC")
            render json: { 
                isSuccess:true, 
                code:1000, 
                message:"키워드 알림 게시글 조회", 
                result: alarms }, status: :ok
        end

    end
end