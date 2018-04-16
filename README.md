# iOSChallenge - TouchBistro

Hello! This is my implementation of the TouchBistro Challenge. The challenge was to add new features to an existing app. The features to be added were:
- Add and delete waiters
- Add shifts to the waiters (I included the deletion of the shifts too)

I created one more feature: a shifts map report. The idea was to create a report to help managers to see the distribution of waiters during the days, to optimize resource allocation. To this report, I used some assumptions:
- The shifts were categorized in Special (between 12 am and 6 am), Morning (between 6:01 am and 12 pm), Afternoon (between 12:01 pm and 6 pm) and Evening (between 6:01 pm and 11:59 pm)
- The shift is classified based on the start date.
- The count is made based on the shifts, not in distinct person. So, for example, if someone has 2 shifts during the morning, one from 8 to 9, and other from 10 to 11, it will be counted twice.

## Some Features Used

During the development, these are some of the features and objects used:
- Autolayout in all screens
- Extend Objective-C classes in Swift
- StackView
- DatePicker

[Note1: the deletion is done by sliding the cell to the left]

[Note2: there are some validations when a shift is added. For example, someone cannot have 2 shifts overlaped]
