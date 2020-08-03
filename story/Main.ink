/* INITIALIZE VARIABLES */

// increased by attending meetings, doing your job, etc.
VAR work_completed = 0

// current hour, 8 total in the work day
VAR hour = 0

// you called the police to deal with Steve's corpse
VAR police_called = false

// you have a blanket in your possession
VAR have_blanket = false

// you have thrown a blanket over Steve's corpse
// TODO: in godot, add listener for when this changes
VAR blanket_steve = false

// you have the fire extinguisher
VAR have_fire_extinguisher = false

// you have stationary in your possession
VAR have_stationary = false

// you put a warning sign on the water cooler
// TODO: in godot, add listener for when this changes
VAR water_cooler_warning = false

// do you know the code to the janitor closet
VAR know_janitor_code = false

// have you unlocked the closet
VAR closet_unlocked = false

// you want to put a sign on the water cooler
VAR need_stationary = false

// after the first hour
VAR everything_is_busted = false

// is it lunch time? special rules apply here
VAR is_lunch = false

// does Becky have fish in the microwave?
VAR fish_in_microwave = false

// is the microwave on fire?
// TODO: in godot, add listener for when this changes
VAR microwave_on_fire = false

// is the office on fire?
VAR office_on_fire = false

// did Dave die at the water cooler?
VAR dave_is_dead = false

// do you know Dave died?
VAR you_know_dave_is_dead = false

// is Dave's computer infected?
VAR dave_computer_infected = false

// Dave has accidentally unleashed his porn.exe virus across the network
VAR porn_virus_unleashed = false

// do you know about the virus?
VAR know_about_virus = false

// you need something from Dave to get any more work done
VAR blocked_by_dave = false

// have you checked on your co-workers yet?
VAR checked_on_coworkers = false

// did you eat lunch?
VAR ate_lunch = false

// where to go after a transition
VAR continuation = -> nowhere

/* ROUTER */

=== progress_hour ===

~ hour = hour + 1

{ hour:
// 9:00 -> 10:00
- 1:
    // set initial flag for everything to go wrong
    ~ everything_is_busted = true
    // Dave manages to infect his computer while you're in a meeting
    ~ dave_computer_infected = true

// 10:00 -> 11:00
- 2:

// 11:00 -> 12:00
// transition to lunch
- 3:
    // direct player to choice about working or not through lunch
    ~ continuation = -> lunch_choice
    // becky microwaving fish
    ~ fish_in_microwave = true

// 12:00 -> 13:00
- 4:
    // it's no longer lunch
    ~ is_lunch = false
    // if the fish is still in the microwave, it catches on fire
    ~ microwave_on_fire = fish_in_microwave

// 13:00 -> 14:00
- 5:
    // if the microwave is still on fire, the office catches on fire
    // this is a game over
    ~ office_on_fire = microwave_on_fire
    // redirect to potential office fire ending
    { office_on_fire:
        ~ continuation = -> ending.office_fire
    }
    // At 14:00, you realize you need something from Dave to get any more work done
    // If you've already sorted his ransomware problem, he's already sent you the code
    ~ blocked_by_dave = true
    // Dave goes to get a drink from the water cooler at 14:00:
    // Definition: blocked = warning sign OR cops called
    ~ temp wc_blocked = water_cooler_warning || police_called
    // if the body is visible, he calls the cops and doesn't drink water
    ~ police_called = !blanket_steve
    // if body is covered and the cooler isn't blocked, he drinks water
    // and dies
    ~ dave_is_dead = blanket_steve && !wc_blocked
    // in all other cases, he just goes back to his desk without doing anything

// 14:00 -> 15:00
- 6:
    // if Dave is alive and his computer is still infected, he plugs
    // in his ethernet and spreads it to the whole network
    ~ porn_virus_unleashed = !dave_is_dead && dave_computer_infected

// 15:00 -> 16:00
- 7:

// 16:00 -> 17:00
// end of day
- 8:
    ~ continuation = -> ending.default
}
-> DONE

// Dummy knot for null continuation
=== nowhere ===
-> DONE

// Router to come back to after a transition/progress_hour
=== continue ===
-> continuation

/* CONTENT */

=== lunch_choice ===

It's lunch time. The office reeks of fish for some reason. Probably Becky. Do you want to go eat lunch or work through lunch?

+ Eat lunch
    ~ is_lunch = true
+ Work through lunch
-
-> DONE

=== intro ===

It's been a good morning. You've managed to clear your inbox, get your coding environment opened up to where you left off, and finish your coffee --- all with no distractions...

... which can only mean your co-workers have been busy screwing something up. You have ten minutes before you have to present in an international meeting. You'd better go check on them.

-> DONE

=== case_of_troubles ===

What is this odd case doing here? On the front, the word "TROUBLES" is crudely carved into the wood. A case of "TROUBLES" then? Whatever was in it, it seems to be empty now.

~ checked_on_coworkers = true

-> DONE

=== your_computer ===

{
    - !everything_is_busted: -> computer_start
    - is_lunch: -> lunch_computer
    - else: -> computer_main
}

= computer_start

{ checked_on_coworkers:
    You sit down at your desk and call into your meeting.
    >>> event morning_meeting
- else:
    Your computer. You'll need this to get that feature out by tomorrow. But first, you should check on your co-workers.
}

-> DONE

= lunch_computer

Your work will be here when you get back from lunch. Probably.

-> DONE

= blocked

You realize that you need some code from Dave to make any more progress on your feature.

{
    - you_know_dave_is_dead: <> But he's dead. Welp.
    - dave_computer_infected: <> But he's not online. You'll have to go talk to him in person. Gross.
    - else:
        <> You shoot him a quick message, and he sends the new code over.
        ~ blocked_by_dave = false
        -> work_on_feature
}

= work_on_feature
{
    - porn_virus_unleashed:
        Your editor has crashed. When you re-open your code, you are presented with a screen of gibberish. Huh?

        Windows filled with wild porn rapidly fill your screen. Uh oh.

        A text window appears. It says: "ur files r all ecnrypt, send mad money 4 me 2 restore them" followed by a bitcoin address.

        The network has somehow been infected with ransomware.

        -> ending.ransomware

    - !blocked_by_dave:
        >>> transition For the next hour, you work on your feature, adamantly refusing to let anything interrupt you.
        ~ temp base_work_score = 8
        { hour > 3 && !ate_lunch:
            ~ base_work_score = base_work_score / 2
        }
        { police_called:
            ~ base_work_score = base_work_score / 4
        }
        ~ work_completed = work_completed + base_work_score
        -> progress_hour
    - else: -> blocked
}
-> DONE

= computer_main

Your computer. You'll need this to get that feature out by tomorrow.

+ Work on feature
    -> work_on_feature
+ Watch PeerTube
    >>> transition You only mean to watch one video, but somehow an entire hour passes and you now know more than you ever wanted to about {&dating panthers|cooking leather products|cutting rubber balls with hot knives|the growing weasel trafficking crisis}.
    -> progress_hour
+ Maybe later

-

-> DONE


=== steve ===

{
    - police_called: -> police_were_called
    - blanket_steve: -> applied_blanket
    - else: -> default
}

= applied_blanket
Eh, good enough.
-> DONE

= police_were_called
Police are here. It's their problem now.
-> DONE

= default
Steve's dead. Rest in peace, Steve. Maybe you should call the cops or throw a blanket over him or something.

+ Call the police
    ~ police_called = true
    You call the police. Better off their problem than yours.
    >>> event call_police
+ Throw a blanket over him
    { have_blanket:
        ~ have_blanket = false
        ~ blanket_steve = true
        You throw a blanket over Steve's corpse. Problem solved.
    - else:
        You don't have a blanket.
    }
+ Ignore it
    Eh, not worth the effort. Steve sucked anyway.
-
-> DONE

=== police ===

{ stopping:
    - Police Officer: Tough case, this. Gonna take a while to get to the bottom of it."
    - Police Officer: Looks like cold, calculated murder to me. Murder weapon either a gun or a knife. Haven't found the wound yet, though. Crafty culprit.
    + "He clearly just drank the nasty water."
        -> nasty_water
    + "Could he have been killed by the water?"
        -> young_detective
    - Police Officer: Back off citizen. I've got important police business to attend to. Like yelling into my radio. BACKUP! BACKUP! I NEED BACKUP!
    Radio: Bzzzt. Shut up, Frank!
    - Police Officer: Who could have done it? Hmm...
}

= young_detective
Police Officer: Ah, we've got ourselves a young detective here! You might just be right. Maybe the culprit forced water into his lungs until he died.
Police Officer: Died by water...
Police Officer: Water unbreathicated...
+ "Drowned?"
    Police Officer: No, no, that's not it.
    The officer rambles nonsense for a while longer. You leave him to it.
    -> DONE
+ "I meant he drank the nasty water and died."
    -> nasty_water

= nasty_water
Police Officer: Who's the detective here, me or you?
-> DONE

=== microwave ===

{
    - !everything_is_busted:
        It's a microwave. Yup.
    - fish_in_microwave:
        There is a fish spinning in the microwave. It reeks. And all the buttons are broken?
    - microwave_on_fire:
        -> firewave
}

= firewave

There is a flaming fish in the microwave. The microwave itself is also on fire.

+ {have_fire_extinguisher && !office_on_fire} Put the fire out
    You use the fire extinguisher on the microwave. The fire goes out.
    ~ microwave_on_fire = false
    >>> transition You've spent the entire hour running around and dealing with a fire. At least the office won't burn down now.
    -> progress_hour
-
-> DONE

=== janitor_closet ===

It's a closet. Has the word "Janitor" on it.

{
    - closet_unlocked: -> unlocked
    - else: -> locked
}

= locked

The closet is locked.

+ {!know_janitor_code} Guess the passcode
    >>> transition You spend the next hour guessing at the 3-digit code and finally get the closet open.
    ~ closet_unlocked = true
    -> progress_hour
+ {know_janitor_code} Enter passcode
    You enter the passcode Jimmy gave you and the door opens.
    ~ closet_unlocked = true
+ Leave
-
-> DONE

=  unlocked

The closet is unlocked.

+ Look inside
    You look inside the closet. There are a bunch of ritual candles, a goat's head, some jars of blood, and surprisingly few cleaning supplies.
    {
        - have_fire_extinguisher && have_blanket:
            There is nothing useful inside.
        - have_fire_extinguisher:
            There is a blanket bunched up in the corner.
        - have_blanket:
            There is a fire extinguisher behind the candles.
        - else:
            There is a fire extinguisher behind the candles and a blanket bunched up in the corner.
    }
    ++ {!have_fire_extinguisher} Take fire extinguisher
        ~ have_fire_extinguisher = true
        You take the fire extinguisher.
    ++ {!have_blanket} Take blanket
        ~ have_blanket = true
        You take the blanket.
    ++ {!have_fire_extinguisher && !have_blanket} Take both
        ~ have_fire_extinguisher = true
        ~ have_blanket = true
        You take the fire extinguisher and the blanket.
    ++ Leave
+ Leave
-
-> DONE

=== water_cooler ===

{
    - everything_is_busted: -> grimy
    - else:
        It's a water cooler. Amazing.
}

= grimy

The water cooler is filled with gnarly green... something. You'd have to be insane to drink from it.

{
    - water_cooler_warning:
        <> There's a warning sign taped to it. Quality work, if you do say so yourself.
    - police_called:
        <> It's covered in caution tape.
    - else:
        -> choices
}

= choices
+ Drink from it
    You drink some of the water. It's actually not so bad after all.
    >>> event died_from_water
+ Put a warning sign on it
    { have_stationary:
        ~ water_cooler_warning = true
        ~ have_stationary = false
        You scribble a quick warning sign and tape it to the water cooler.
    - else:
        ~ need_stationary = true
        You'll need a piece of paper, a marker, and some tape. Becky loves putting up motivational posters on the walls. She probably has some stationary you can use.
    }
+ Ignore it
    Not your problem. Who'd be dumb enough to drink from this anyway?

    ... aside from Steve.
-
-> DONE

=== becky ===

{
    - !everything_is_busted: -> becky_intro
    - is_lunch: -> becky_lunch
    - microwave_on_fire: -> becky_kitchen
    - else: -> default_becky
}

= becky_intro

Becky: Good morning! But really, it is quite a beautiful morning, wouldn't you agree? You know, I thought just that while standing at the bus stop with my kids this morning. "Beautiful, morning," ya know? Oh, speaking of my kids, Billybob did the funniest-

+ "Morning, Becky."
* "What's with the case?"
    Becky: Oh, that old thing? Dave brought it in this morning. Heaven knows where he found it, but it was the funniest thing. We opened it up, and guess what was inside...
    ** "Nothing?"
    ** "Surprise me."
    --
    Becky: Nothing! Though I did get the strangest sensation that someone had gone terribly wrong when we opened it. Like we'd let something out we shouldn't have. You know the feeling?
    ** "Only when you're talking to me."
        Becky: Oh, you are such a joker! Now, as I was saying about my kids...
        *** "Maybe another time, Becky."
            -> DONE
    ** "Nope, gotta go."
        -> DONE
-
~ checked_on_coworkers = true
-> DONE

= becky_lunch

Becky: Good afternoon! Are you here for lunch too? I'm just heating up some fish. Some very moist fish. I've got to leave it in there for a long time to remove the bad vibes. I read that on the Pescatarian Moms website. Not that I'm pescatarian---I love me a burger with some crispy bacon every once in a while---but fish helps you keep your figure. And besides-

+ "I think your fish is done."
    Becky: You think so? Well, you have a great figure, so you probably know your fish diets.
    Becky: ...
    Becky: Okay, so this is a little embarrassing, but I've somehow gotten the microwave door jammed. Uh, and broken all the buttons.
    Becky: Can you help me get it opened? That should make it turn off and save my fish.
    ++ "Yeah, fine."
        >>> transition You spend the rest of your lunch hour jamming random things into the microwave door and eventually get it open with just enough time to eat your own lunch. Becky goes back to her office with a [i]very[/i] dry fish.
        ~ fish_in_microwave = false
        -> progress_hour
    ++ "Nah, good luck."
+ Let Becky keep talking
    >>> transition You patiently listen while Becky rambles about her diet, and her kids' diets, and her goldfish's diet, and something about her great, great grandfather? She talks through your entire lunch hour. At some point, the microwave catches fire. At least you manage to eat your lunch while she talks.
    -> progress_hour
-
-> DONE

= becky_kitchen

Becky: I don't think it's quite done yet.
-> DONE

= default_becky

Becky: Oh, hello! Have you come to chat? I'm very busy today, but I do love me a quick conversation to break up the monotony.

* {need_stationary && !have_stationary} "Can I borrow a marker, some paper, and some tape?"
    Becky: Sure! Here you go.
    Becky gives you some stationary.
    ~ have_stationary = true
+ Chat with becky
    >>> transition You let Becky ramble on and on about whatever nonsense it is she does with her life for an entire hour.
    -> progress_hour
+ "Sorry, no time."
-
-> DONE

=== Dave ===

{
    - !everything_is_busted: -> dave_intro
    - dave_is_dead: -> dead_dave
    - dave_computer_infected: -> ransomware_dave
    - else: -> done_with_dave
}

= done_with_dave

Dave: Thanks for the help! Now I can get back to work.

-> DONE

= dave_intro

Dave: Hey, hey! You missed all the fun! We just opened the case!

* "What was in it?"
    Dave: Nothing!
* "Where'd that case come from?"
    Dave shrugs.
    Dave: No clue. Found it in the dumpster out back. So, obviously, I brought it in here and opened it.
+ "Yeah, I see that."

-

~ checked_on_coworkers = true
-> DONE

= dead_dave

Dave drank the nasty water and died. RIP Dave.
~ you_know_dave_is_dead = true
-> DONE

= ransomware_dave

Dave: Hey, can ya help me out a sec?

+ "What's wrong?"
    Dave: Well, it seems I, uh, might've found this... flash drive?
    ++ "And?"
    ++ "Okay..."
    --
    Dave: Heh, well, ya see... there was this file on it called porn.exe.def-not-ransomware.bat.jpg.exe...
    Dave: ...
    Dave: Someone, who may or may not be me, [i]miiiiight[/i] have clicked on it?
    Dave: I think it knocked out my internet.
    +++ Debug his internet
        After more poking around in terminal than you care to admit, you decide to check his ethernet cable and find that it's unplugged.
        ++++ Plug it in
            You plug in the ethernet cable, and Dave's internet reconnects. Windows filled with wild porn rapidly fill his screen.

            Dave: Oh, nice. You want me to send you some of this?
            +++++ "Hell, yeah!"
            +++++ "No way!"
            -----
            ~ porn_virus_unleashed = true

            Before you have a chance to respond, a pop up with just text shows up. It says: "ur files r all ecnrypt, send mad money 4 me 2 restore them" followed by a bitcoin address.

            You have infected the network with ransomware.

            -> ending.ransomware

        ++++ Don't plug it in
            You don't plug in his ethernet.
    +++ Call the IT department
        You call the IT department and tell them about Dave's problem.
        >>> transition Two IT guys arrive, dressed in hazmat suits. One puts Dave's computer under his arm. The other puts Dave under his arm. They say to follow them. You spend the next hour sorting out Dave's mess with the IT department.
        ~ dave_computer_infected = false
        -> progress_hour
+ "No time, solve your own problems, man."
    Dave: Okay.
-
-> DONE

=== jimmy ===

{
    - !everything_is_busted: -> jimmy_intro
    - else: -> jimmy_default
}

= jimmy_intro

{ stopping:
    - Jimmy: Morning. You see the weird case Dave brought in? Got a bad feeling about it, but I got here too late to stop them.

    Jimmy: ... Dave shouldn't be allowed to open things.

    - Jimmy: Spent the last hour searching the office for the fire extinguisher. Janitor moves it to a different spot every night, Lord knows why.

    - Jimmy: ... Dave shouldn't be allowed to open things.
}

~ checked_on_coworkers = true
-> DONE

= jimmy_default

Jimmy: Hey. Can't wait 'til the weekend, right?

* {microwave_on_fire} "So, the microwave's on fire..."
    Jimmy: And this is why I spend the first hour of every day figuring out where the janitor's hidden the fire extinguisher. Such a waste of time...
    Jimmy: Anyway, he's stashed it in his closet. Passcode is 666. It's right behind all of the janitor's ritual candles.
    Jimmy: ... I'm a little concerned about the people we hire.
    ~ know_janitor_code = true
+ "That's for sure."
-
-> DONE

=== ending ===

= ransomware
TODO: fill this in
-> END

= office_fire
TODO: fill this in
-> END

= default
TODO: fill this in
-> END
