Rails.application.routes.draw do
  root to: 'home#index'

  get '/:size/:bg_color/:fg_color', to: 'home#image'
  get '/:size/:bg_color', to: 'home#image'
  get '/:size', to: 'home#image'
  

  get '/:size/:bg_color(.:format)*extra_data', to: 'home#image'
  get '/:size(.:format)*extra_data', to: 'home#image'

end
