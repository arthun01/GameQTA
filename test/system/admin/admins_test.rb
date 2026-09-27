require "application_system_test_case"

class Admin::AdminsTest < ApplicationSystemTestCase
  setup do
    @admin = admins(:one)

    # Login as admin
    visit new_admin_session_path
    fill_in "email_address", with: @admin.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_text "Dashboard"
  end

  test "creating a new admin" do
    visit admin_admins_path
    
    click_on "Novo Administrador"
    
    fill_in "E-mail", with: "novo_admin@example.com"
    fill_in "Senha", with: "secret123"
    fill_in "Confirme a Senha", with: "secret123"
    
    click_on "Salvar"
    
    assert_text "Administrador criado com sucesso."
    assert_text "novo_admin@example.com"
  end

  test "updating an admin" do
    visit admin_admins_path
    
    within(first("tbody tr")) do
      click_on "Editar"
    end
    
    fill_in "E-mail", with: "admin_atualizado@example.com"
    # Deixando senha em branco
    
    click_on "Salvar"
    
    assert_text "Administrador atualizado com sucesso."
    assert_text "admin_atualizado@example.com"
  end

  test "destroying an admin prevents deleting the last one" do
    # Deleta todos exceto 1
    Admin.where.not(id: @admin.id).destroy_all

    visit admin_admins_path

    # The Excluir button shouldn't exist if there's only 1 admin left
    assert_no_button "Excluir"
  end

  test "destroying an admin works if there are more than 1" do
    new_admin = Admin.create!(email_address: "extra@example.com", password: "password")
    
    visit admin_admins_path

    within("#admin_#{new_admin.id}") do
      click_on "Excluir"
    end

    assert_text "Administrador excluído com sucesso."
    assert_no_text "extra@example.com"
  end
end
