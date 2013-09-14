Dummy::Application.routes.draw do
  root to: 'examples#index'
  resource :examples
end
