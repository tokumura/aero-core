# coding: utf-8
require 'spec_helper'

describe Department do

  fixtures :departments

  context "複数部署がある場合" do
    before do
      @departments = Department.all
    end
    it "全件検索時、全部署が取得される。" do
      @departments.size.should == 3
    end
  end

  context "ID:1が'ORCA事業部'の場合" do
    before do
      @department = Department.find(1)
    end
    it "部署名は'ORCA事業部'である" do
      @department.name.should == "ORCA事業部"
    end
  end





end
