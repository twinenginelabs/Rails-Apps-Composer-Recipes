RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory

    new do
      except ["Role", "Identity"]
    end
    export do
      except []
    end
    show do
      except ["Role"]
    end
    edit do
      except ["Role", "Identity"]
    end
    delete do
      except ["Role"]
    end
    bulk_delete do
      except ["Role"]
    end
    history_index do
      except ["Identity"]
    end
    history_show do
      except ["Identity"]
    end
  end

  config.model "User" do
    edit do
      configure :identities do
        visible false
      end
    end
  end

end