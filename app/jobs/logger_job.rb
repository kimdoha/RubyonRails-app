class LoggerJob
  include SuckerPunch::Job
  # workers 4 (default : 2 => worker 조절 가능)
  # max_jobs 10 (jobs의 갯수 제한 가능)

  def perform
    raise NotImplementedError
  end
end
