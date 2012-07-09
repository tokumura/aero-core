# coding: utf-8
require 'spec_helper'

describe "departments/new" do
  fixtures :departments
  before do
    @department = Department.find(departments(:orca).id)
  end

  it "部署名のテキストボックスが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "department[name]", :value => @department.name)
    end
  end

  it "登録ボタンが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "submit", :value => "　登　録　")
    end
  end
end
