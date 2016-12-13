class Bot
    @@c1 = 17
    @@c2 = 61

    def initialize(id, n1=0, n2=0)
        @id = id
        @n1 = [n1.to_i, n2.to_i].min
        @n2 = [n1.to_i, n2.to_i].max
    end

    def accept(n)
        @n1, @n2 = [@n1, @n2, n.to_i].select {|n| !n.nil? && n != 0}.minmax
        @n2 = @n1 == @n2 ? 0 : @n2 
    end

    def passLowTo(other)
        other.accept @n1
        @n1 = 0
    end

    def passHighTo(other)
        other.accept @n2
        @n2 = 0
    end

    def hasTwoValues?
        return @n1 != 0 && @n2 != 0
    end

end

class Bin 
    def initialize(id)
        @id = id
        @list = Array.new
    end

    def accept(val)
        @list.push val
    end

    def first
        @list[0]
    end
end

def main
    bots = Hash.new
    outs = Hash.new

    lines = File.readlines('input.txt')
    while lines.length > 0 do 
        line = lines.shift
        parts = line.split
        
        if parts[0] == 'bot'
            _, botId, _, _, _, lowBotOrOut, lowBotId, _, _, _, highBotOrOut, highBotId = parts
            
            bot = (bots[botId] ||= Bot.new botId)
            lowBot = if lowBotOrOut == 'bot' then (bots[lowBotId] ||= Bot.new lowBotId) else (outs[lowBotId] ||= Bin.new lowBotId) end
            highBot = if highBotOrOut == 'bot' then (bots[highBotId] ||= Bot.new highBotId) else (outs[highBotId] ||= Bin.new highBotId) end

            if bot.hasTwoValues?
                bot.passLowTo lowBot
                bot.passHighTo highBot
            else
                lines.push line
                next
            end

        else
            _, val, _, _, _, botId = parts
            (bots[botId] ||= Bot.new botId).accept val
        end

    end

    mul = outs['0'].first * outs['1'].first * outs['2'].first
    print "The multiplied values of each's first chip in output bin '1', '2' and '3' are #{mul}", "\n"

end

if __FILE__ == $0
  main()
end