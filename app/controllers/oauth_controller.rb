#coding: utf-8

#Oauth認証するためのコントローラー
class OauthController < ApplicationController
  
  #Facebookエントリーボタンがあるページをレンダリングするアクション
  def index


  end
 
  #Facebookにリダイレクトして、oauth認証をするメソッド 
  def get
    #oauthクラスをつくるための変数
    @app_id = "365597716864793"
    @app_secret = "2fbb263ae24e45a381dcece4782cfbfe"
    @args = {:site => 'https://graph.facebook.com', :token_url => '/oauth/access_token', :ssl => { :verify => false } } 

    #OAuth2::Clientオブジェクトを取得
    @client = OAuth2::Client.new( @app_id ,@app_secret, @args)
    
    #プロバイダーにリダイレクトし、認証させる。
    @callback_url = url_for(:controller => "oauth",:action => "callback")
    
    #facebookに認証する。
    redirect_to @client.auth_code.authorize_url(:redirect_uri => @callback_url)


  end


  #facebookからダイレクトされたときにするアクション
  def callback
    
    #oauthクラスをつくるための変数
    @app_id = "365597716864793"
    @app_secret = "2fbb263ae24e45a381dcece4782cfbfe"
    @args = {:site => 'https://graph.facebook.com', :token_url => '/oauth/access_token', :ssl => { :verify => false } } 

    #OAuth2::Clientオブジェクトを取得
    @client = OAuth2::Client.new( @app_id ,@app_secret, @args)

    #callback_urlをつくる。このときに、認証の時と、アクセストークンのときのcallback_urlは同じでないとエラーが起こる。
    @callback_url = url_for(:controller => "oauth",:action => "callback")
    
    #フォーマットを決める。
    @header_format = 'OAuth %s'
    @access_token = @client.auth_code.get_token( params[:code], {:redirect_uri => @callback_url,
        :parse => :query }, {:header_format => @header_format})
    
    #ユーザーのデータを取得して、user変数に格納する。
    @user_data = @access_token.get("/me/").parsed
    logger.debug(@user_data)


  end




end
