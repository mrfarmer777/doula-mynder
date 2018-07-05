require 'spec_helper'
require 'pry'

describe ApplicationController do

  describe "Homepage" do
    it "loads the homepage" do
      get "/"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Doula Mynder")
    end
  end

  describe "Signup Page" do
    it "loads the signup page" do
      get "/signup"
      expect(last_response.status).to eq(200)
    end

    it "creates a new user and logs them in on a valid submission." do
      params={
        name: "Sally Ride",
        username: "sallyride",
        email: "sally@ride.com",
        password: "rockets",
        company_name: "Rocket Doula",
      }

      post "/signup", params
      get "/signup"
      expect(last_response.location).to include("/dashboard")

    end

    it "redirects to login when form submitted with empty username" do
      user_count=User.all.count

      params={
        name: "Sally Ride",
        username: "",
        email: "sally@ride.com",
        password: "rockets",
        company_name: "Rocket Doula",
      }

      post "/signup", params
      new_user_count=User.all.count
      expect(last_response.location).to include("/signup")
      expect(new_user_count).to eq(user_count)
    end

    it "redirects to login when form submitted with empty password" do
      user_count=User.all.count

      params={
        name: "Sally Ride",
        username: "username",
        email: "sally@ride.com",
        password: "",
        company_name: "Rocket Doula",
      }

      post "/signup", params
      new_user_count=User.all.count
      expect(last_response.location).to include("/signup")
      expect(new_user_count).to eq(user_count)
    end

  end

  describe "Login Page" do
    it "loads the login form" do
      get "/login"
      expect(last_response.status).to eq(200)
    end

    it "logs in a valid user when credentials are correct" do
      user=User.create(username:'sallyride',name:"Sally Ride",company_name:"Rocket Doulas",password:"password")

      visit "/login"
      fill_in(:username, :with =>"sallyride")
      fill_in(:password, :with =>"password")
      click_button "submit"
      expect(page.body).to include('Welcome,')
    end

  end
end
