module ApplicationHelper
  def pluralize_item(count, first_case, second_case, third_case )
    last_digit = count % 10
    last_two_digits = count % 100

    if last_two_digits >= 11 && last_two_digits <= 14
      "#{count} #{third_case}"
    elsif last_digit == 1
      "#{count} #{first_case}"
    elsif last_digit >= 2 && last_digit <= 4
      "#{count} #{second_case}"
    else
      "#{count} #{third_case}"
    end
  end 
end
