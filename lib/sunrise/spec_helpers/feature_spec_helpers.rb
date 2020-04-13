# frozen_string_literal: true

def horizontal_scroll_position(selector)
  page.evaluate_script("$('#{selector}').scrollLeft()")
end

def vertically_scroll_to(selector)
  page.execute_script(
    "window.scrollTo(0, $('#{selector}')[0].getBoundingClientRect().top)"
  )
end

def scroll_to_bottom
  page.execute_script('window.scrollTo(0,document.body.scrollHeight)')
end

def wait_until_animation_finishes(selector)
  loop do
    animation_queue = page.evaluate_script("$('#{selector}').queue()")
    break if animation_queue.empty?
  end
end

def click_on_element(element)
  if @device == %i[chrome_desktop]
    element.click
  else
    page.execute_script('arguments[0].click();', element)
  end
end

def expect_to_have_content_only_on_desktop(device, content)
  if device[:name] == :chrome_desktop
    expect(page).to have_content(content)
  elsif device[:name] == :chrome_android_phone
    expect(page).not_to have_content(content)
  end
end

def expect_to_have_content_only_on_mobile(device, content)
  if device[:name] == :chrome_android_phone
    expect(page).to have_content(content)
  elsif device[:name] == :chrome_desktop
    expect(page).not_to have_content(content)
  end
end

def expect_to_have_link_only_on_desktop(device, link_content, option = {})
  if device[:name] == :chrome_desktop
    expect(page).to have_link(link_content, option)
  elsif device[:name] == :chrome_android_phone
    expect(page).not_to have_link(link_content, option)
  end
end

def set_daterangepicker_date(first_date, last_date)
  find('.daterangepicker-field').click

  within '.daterangepicker.show-calendar' do
    within ".#{first_date[:side]}" do
      find(
        'td.available:not(.ends)',
        text: first_date[:number], exact_text: true
      )
        .click
    end

    within ".#{last_date[:side]}" do
      find('td.available', text: last_date[:number], exact_text: true).click
    end
    click_button('Appliquer')
  end
end
