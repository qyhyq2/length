class Length
  def initialize
    @map = Hash.new
    @result = Array.new(10,0)
    @count = 0
  end
  
  def map
    @map
  end
  
  def setFile(fn = "input.txt")
      @file = fn
  end
  
  def readFile()
      File.open(@file,"r") do |file|
          while line=file.gets
              if match = /\s*\d+\s*(\w+)\s*=\s*(\d+.\d*)\s*m\s*/.match(line)       
                  @map[match[1]] = match[2].to_f
              elsif line.lstrip!=""
                calculate(toSingle(line),@count)
                @count += 1 
          end
      end
  end
  
  #把复数变成单数
  def toSingle(str)
    str = str.gsub(/miles/,"mile")    
    str = str.gsub(/inches/,"inch") 
    str = str.gsub(/feet/,"foot") 
    str = str.gsub(/yards/,"yard")
    str = str.gsub(/faths/,"fath")
  end
  
  #转化成米为单位
  def transfer(str)
    if  match = /\s*(\d+(.\d+){0,1})\s*(\w+)/.match(str)
      return match[1].to_f * @map[match[3]]
    end
  end
  
  #计算表达式
  def calculate(str,n)
    if  match = /(\s*\d+(.\d+){0,1}\s*\w+)((\s*([+-])\s*\d+(.\d+){0,1}\s*\w+)*)/.match(str)
      @result[n] += transfer(match[1])
    end
    if match[3].to_s.lstrip != ""
      substr = match[3]
      while subMatch = /(([+-])\s*\d+(.\d+){0,1}\s*\w+)(\s*[+-][\d\w\s.]+)*/.match(substr)
        if subMatch[2] == "+"
          @result[n] += transfer(subMatch[1])
        elsif subMatch[2] == "-"
          @result[n] -= transfer(subMatch[1])
        end
        if subMatch[4].to_s.lstrip != ""
            substr = subMatch[4]
        else
            break
        end
      end
      
    end
  
  #保留两位小数
  def doFormat
    10.times do |i|
      @result[i] = format("%.2f",@result[i])
    end
  end
  
  #写入文件
  def appendFile
    f = File.new("output.txt","w") #覆盖---w 追加---a
      f.puts("yuhangqn@gmail.com")
      f.puts
      10.times do |i|
          f.puts(@result[i].to_s + " m" )
      end
    f.close
  end
  
end


f = Length.new
f.setFile
f.readFile
f.doFormat
f.appendFile

