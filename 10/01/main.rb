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

        self.check
    end

    def passLowTo(other)
        other.accept @n1
        @n1 = 0
    end

    def passHighTo(other)
        other.accept @n2
        @n2 = 0
    end

    def check
        if @n1 == @@c1 && @n2 == @@c2
            print "Bot no. #{@id} is currently responsable for comparing #{@n1} and #{@n2}", "\n"
        end
    end

    def hasTwoValues?
        return @n1 != 0 && @n2 != 0
    end

end

def main
    bots = Hash.new
    
    lines = File.readlines('input.txt')
    while lines.length > 0 do 
        line = lines.shift
        parts = line.split
        
        if parts[0] == 'bot'
            _, botId, _, _, _, lowBotOrOut, lowBotId, _, _, _, highBotOrOut, highBotId = parts
            
            bot = (bots[botId] ||= Bot.new botId)
            lowBot = if lowBotOrOut == 'bot' then (bots[lowBotId] ||= Bot.new lowBotId) else Bot.new nil end
            highBot = if highBotOrOut == 'bot' then (bots[highBotId] ||= Bot.new highBotId) else Bot.new nil end

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

end

if __FILE__ == $0
  main()
end