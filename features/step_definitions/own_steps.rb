Given /^joyn app is running on the First Device$/ do
$device=1
    $startTime = Time.now.to_f
      performAction('wait_for_view_by_id','contacts_toggle_filter_txtview', true)
     waitTillViewIsShown('contacts_toggle_filter_txtview', 120)
    elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: joyn;startup|Startup time for app till the joyn contacts being displayed in the fist device: time="+elapsedTime.to_s+"s"
end

Then /^I delete the chat history in the first Device$/ do
$device=1
performAction('wait_for_view_by_id','contact_row_name')
performAction('select_from_menu', 'Delete all messages')
performAction('wait_for_text', 'Yes')
performAction('click_on_text', 'Yes')
end

Then /^I take a screenshot in the first Device$/ do
$device=1
screenshot_embed
end

And /^also in Second Device joyn app is running$/ do
$device=2
uninstall_apps
install_app(ENV["TEST_APP_PATH"])
$startTime = Time.now.to_f
start_test_server_in_background
        performAction('wait_for_view_by_id','contacts_toggle_filter_txtview', true)
     waitTillViewIsShown('contacts_toggle_filter_txtview', 120)
    elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: joyn;startup|Startup time for app till the joyn contacts being displayed in the second device: time="+elapsedTime.to_s+"s"
end


Then /^I delete the chat history in the second Device$/ do
$device=2
performAction('wait_for_view_by_id','contact_row_name')
performAction('select_from_menu', 'Delete all messages')
performAction('wait_for_text', 'Yes')
performAction('click_on_text', 'Yes')
end

And /^I take a screenshot in the Second Device$/ do
$device=2
screenshot_embed
end

Then /^I pree back button to close Joyn UI$/ do
$device=2 
performAction('go_back')
# clearing notification event log in device 2
system 'adb -s $ADB_DEVICE_ARG2  logcat -b events -c'
end


When /^I see the contact '(.*)' in joyn contacts list of the first device$/ do |device2|
$device=1
while  (true == performAction('assert_text',device2,true))
performAction('scroll_down')
end
#performAction('wait_for_text', device2)
end

Then /^I select the contact '(.*)' in joyn contacts list$/ do |device2|
$device=1
performAction('click_on_text', device2)
performAction('wait_for_view_by_id','contactcard_entry_text2')
performAction('click_on_view_by_id','contactcard_entry_text2')
end

Then /^I start to chat with the message '(.*)'$/ do |message1|
$device=1
performAction('wait_for_view_by_id','chat_composer')
performAction('enter_text_into_id_field',message1,'chat_composer')
performAction('wait_for_view_by_id','chat_send_button')
performAction('click_on_view_by_id','chat_send_button')
$startTime = Time.now.to_f
end

When /^I see the Joyn Notification message in Second Device$/ do
$device=2
count = 1
value =""
while  (value == "")
value=`adb -s $ADB_DEVICE_ARG2 logcat -b events -d  -v threadtime |grep com.summit.beam |grep notification_enqueue |grep flags=0x10`
sleep(1.0/5.0)
if count == 100
performAction('wait_for_text', "Android Notification for Joyn message",1)
else
count = count + 1
end 
end
  elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: joyn;Notification msg|Time elapsed between send msg in first device and received notification in second; time ="+elapsedTime.to_s+"s"
end

Then /^I take a screenshot in the second Device$/ do
$device=2
screenshot_embed
end

When /^I open the notification message$/ do
$device=2
system 'monkeyrunner Notification.py TestDevice1 $ADB_DEVICE_ARG2'
end

Then /^I see the message '(.*)' from first device$/ do |message2|
$device=2
performAction('wait_for_text', message2)
performAction('assert_text',message2, true)
end

Then /^I send '(.*)'as a reply to first device$/ do |message3|
$device=2
performAction('enter_text_into_id_field',message3,'chat_composer')
performAction('wait_for_view_by_id','chat_send_button')
performAction('click_on_view_by_id','chat_send_button')
$startTime = Time.now.to_f
sleep 5
end


Then /^I wait to see message '(.*)' in the first device$/ do |message4|
$device=1
startTime = Time.now.to_f
performAction('wait_for_text', message4)
    elapsedTime = Time.now.to_f - $startTime
   puts "KPI-For-Nagios: joyn;Message recived|Time elapsed between send msg in second device and received it in first; time ="+elapsedTime.to_s+"s"
performAction('assert_text',message4, true)
end

def waitTillViewIsShown(viewId, timeOut)
    puts "Wait on device: " + $device.to_s
    endTime = Time.now.to_f + timeOut.to_f
    begin
        r = performAction('read_visibility_for_view_by_id', viewId)
        info = r["bonusInformation"].to_s
        sleep 0.2
    end while info == 'false' && Time.now.to_f < endTime.to_f
    if info == 'false' then
        macro 'I take a screenshot'
        assert(false ,'View with id ' + viewId + ' was not able to show up in time')
    end
    return false
end

