# DIDV User Experience class

module DIDV

  class UX

    state_machine :state, initial: :welcome do

      state :welcome do
        def send_data
          puts DIDV::draw_lines "DIDV"
        end
      end

      state :menu do
        def send_data
          puts DIDV::draw_lines "Menu"
        end
      end

      state :ler do
        # ler
      end

      state :escrever do
        # escrever
      end

      state :desligar do
        # desligar
      end

      state :criar do
      end

      state :recebe_char do
      end

      state :avanca_char do
      end

      state :volta_char do
      end

      state :deleta_char do
      end

      state :recebe_eol do
      end

      state :sair do
      end

      state :salvar do
      end

      state :nao_salvar do
      end

      state :cancelar do
      end

      event :welcome_timeout do
        transition :welcome => :menu
      end

      event :seleciona_ler do
        transition :menu => :ler
      end

      event :seleciona_escrever do
        transition :menu => :criar
      end

      event :volta_para_menu do
        transition [:ler,:criar] => :menu
      end

      event :seleciona_desligar do
        transition :menu => :desligar
      end

    end

  end

end
