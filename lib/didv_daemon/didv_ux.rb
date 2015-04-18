# DIDV User Experience class

class DIDV_UX

  state_machine :state, initial: :welcome do

    event :welcome_timeout do
      transition :welcome => :menu
    end

    state :welcome do
    #  puts DIDV::draw_lines "DIDV"
    end

    state :menu do
    #  puts DIDV::draw_lines "Menu"
    end

  end

end
