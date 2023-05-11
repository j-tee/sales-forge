Rails.application.config.session_store :cookie_store, key: '_sales_forge_session', secure: Rails.env.production?
