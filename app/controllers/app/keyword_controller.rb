module App
    class KeywordController < ApplicationController
        def index
            keywords = Keyword.select("keywordId, userId, keyword").order('createAt DESC')
            render json: { isSuccess:true, code:1000, message:"내 키워드 전체조회 완료", result: keywords }, status: :ok
        end

    end
end