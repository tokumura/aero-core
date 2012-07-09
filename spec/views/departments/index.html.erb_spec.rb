# coding: utf-8
require 'spec_helper'

describe "departments/index" do
  fixtures :departments
  before do
    @departments = Department.all
  end
  it "全部署が表示されている" do
    render
    rendered.should have_content(departments(:orca).name)
    rendered.should have_content(departments(:ikibu).name)
    rendered.should have_content(departments(:fs).name)
  end

  it "編集ボタンが表示されている" do
    render
    rendered.should have_content(" 編　集 ")
  end

  it "削除ボタンが表示されている" do
    render
    rendered.should have_content(" 削　除 ")
  end
end
