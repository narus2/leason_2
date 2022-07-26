
ACTION_STATATE = {
    exit: 0,
    stop: 1,
    attack: 2,
    run: 3,
    sleep: 4,
    eat: 5,


    ststus: 9
}

class Animal 
    attr_reader :name, :available_actions
    attr_writer :available_actions

    def initialize(name = 'ruby')
        @name = name
        @eat = 10
        @stamina = 10
        @power_attack = 10
        @date_sleep = Time.now
        update_actions(ACTION_STATATE[:stop])
        @message = ""
        @war = false
    end   
     
    def action(act )
        res = true
        old_status = @action_state
        if self.available_actions.any?(act) 
            update_actions(act)
            case act
            when ACTION_STATATE[:stop]
                res = self.amimal_stop()
                return
            when ACTION_STATATE[:sleep] 
                res = self.amimal_sleep()
                return
            when ACTION_STATATE[:run] 
                res = self.amimal_run()
                return
            when ACTION_STATATE[:eat] 
                res = self.amimal_eat()
                return
            when ACTION_STATATE[:attack] 
                res = self.amimal_attack()
                return
            else
                @message = 'Я не можу це зробити'
                res = false
            end
        else
            @message = 'Я тебе не розумію'
        end
        
        unless res
            update_actions(old_status)
            @message = old_status
        end
    end    
    
    def status
        system("clear")
        puts "Привіт я '#{self.name}' \n" \
            "Зараз я находжусь в статусі: #{ACTION_STATATE.key(@action_state)} \n" \
            "В мене: \n" \
              "     життя: #{@stamina}/10 \n" \
              "     атака: #{@power_attack}/10 \n" \
              "     ситість: #{@eat}/10 \n" \
            " примітка: #{@message} \n" \
            "Я можу виконати наступні дії: \n" \
            " #{ self.available_actions.map{ |e|  "#{e} - #{ACTION_STATATE.key(e.to_int)}"     } } \n" \
            "В ведіть дію: "       
    end    
    private

    def amimal_stop()
        if @action_state = ACTION_STATATE[:sleep] 
            if Time.now - @date_sleep >= 10  
               @message = 'Я виспався'
               update_actions(ACTION_STATATE[:stop])
               return true
            else
                @message = 'Я ще не виспався'
                return false
            end
        else
            update_actions(ACTION_STATATE[:stop])
            return true
        end
    end    

    def amimal_sleep()
        update_actions(ACTION_STATATE[:sleep])
        @date_sleep = Time.now
        @stamina = 10
        @power_attack = 10
    end    

    def amimal_eat()
        @eat = 10
        return true
    end    

    def amimal_run()
        while @eat > 1 
           @eat -= 1
           if rand(10) > 7 
               @war = true
               p "Ми знайшли орка. Знищемо його(так - 1, нi - 2)?"
               comand = gets.chomp
               if comand = 1 
                    self.amimal_attack()
                end 
               return true
           end
        end    
    end    

    def amimal_attack()
        ork_st = 5
        ork_at = 5
        while (ork_at > 0) & (@power_attack > 0) & (ork_st > 0) & (@stamina > 0)
            ork_at -= 1
            @power_attack -= 1
            
            ork_st -= rand(@power_attack)           
            @stamina -= rand(ork_at)
        end
        if @stamina > ork_st
            @message = "Viktory"
            return true
        else
            @message = "False"
            return false
        end    
    end    
    


    def update_actions(cur_action)
       @action_state = cur_action
       case cur_action
       when ACTION_STATATE[:stop]
            self.available_actions = [ACTION_STATATE[:sleep], ACTION_STATATE[:eat], ACTION_STATATE[:run], ACTION_STATATE[:exit] ]
        else
            self.available_actions = [ACTION_STATATE[:stop]]
       end
    end    
end    


class Cli
    def start
        "Ласкаво просимо до гри.\n\n" \
        "Будласка введить ім'я для своеї тваринки:"
    end    

    def run
        puts start
        comand = gets.chomp
        animal = Animal.new(comand)        
        while comand != "0"
            animal.status()
            comand = gets.chomp
            if comand != "0" 
                animal.action(comand.to_i)
            end    
        end
        
    end    

end


cli = Cli.new
cli.run
