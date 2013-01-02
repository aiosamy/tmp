Feature: Chat Feature

  Scenario: As a valid user I can chat with my joyn contact
    Given joyn app is running on the First Device
    Then I delete the chat history in the first Device
    Then I take a screenshot in the first Device

    And also in Second Device joyn app is running
    Then I delete the chat history in the second Device
    And I take a screenshot in the Second Device
    Then I put the Joyn app in background
    Then I take a screenshot in the second Device

    When I see the contact 'TestDevice2' in joyn contacts list of the first device
    Then I select the contact 'TestDevice2' in joyn contacts list
    Then I start to chat with the message 'first joyn chat message'
    Then I take a screenshot in the first Device 
 
    When I see the Joyn Notification message in Second Device
    Then I take a screenshot in the second Device
    When I open the notification message
    Then I see the message 'first joyn chat message' from first device
    Then I send 'first joyn chat message ack'as a reply to first device
    Then I take a screenshot in the second Device

    Then I wait to see message 'first joyn chat message ack' in the first device
    Then I take a screenshot in the first Device
    
    
