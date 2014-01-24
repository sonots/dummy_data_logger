module Dummer
  class Setting
    attr_accessor :rate, :output, :labeled, :delimiter, :fields, :workers, :message, :input

    def initialize
      @rate = 500
      @output = STDOUT
      @labeled = true
      @delimiter = "\t"
      @fields = nil
      @workers = 1
      @message = "time:2013-11-25 00:23:52 +0900\tlevel:ERROR\tmethod:POST\turi:/api/v1/people\treqtime:3.1983877060667103\n"
      @input = nil
    end
  end
end