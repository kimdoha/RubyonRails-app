module App
    class KeywordController < ApplicationController

        # @Get http://localhost:3000/app/keyword
        # 키워드 전체 조회
        def index
            keywords = Keyword.select("keywordId, userId, keyword").order('createAt DESC')
            render json: { 
                isSuccess:true, 
                code:1000, 
                message:"내 키워드 전체조회 완료", 
                result: keywords }, status: :ok

        end

        
        # @Post http://localhost:3000/app/keyword
        # 키워드 생성
        def create
            keyword = Keyword.new(keyword_params)

            if keyword.save
                render json: { 
                    isSuccess:true, 
                    code:1000, 
                    message:"키워드 생성 완료", 
                    result: keyword }, status: :ok
            else
                render json: { 
                    isSuccess:false, 
                    code:3001, 
                    message:"키워드 생성 실패", 
                    result: keyword.errors }, 
                status: :unprocessable_entity
            end
        end


        # @DELETE http://localhost:3000/app/keyword
        # 키워드 삭제
        def destroy
            keyword = Keyword.find(params[:id])
            keyword.destroy
            render json: { 
                isSuccess:true, 
                code:1000, 
                message:"키워드 삭제 완료", 
                result: keyword }, status: :ok
        end


        private
        def keyword_params
            params.permit(:keyword)
        end

    end
end