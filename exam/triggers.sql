--JAKUB
CREATE OR REPLACE FUNCTION check_loaner_count() RETURNS TRIGGER AS $$
DECLARE
    phone_number varchar;
BEGIN
    -- Check if the runner wants to receive an SMS and has a phone number
    IF NEW.wants_race_time_on_sms = true THEN
        -- Fetch the phone number from the profile
        SELECT p.phone_number INTO phone_number
        FROM profile p
        WHERE p.email = NEW.profile_email;

        -- Check if the phone number is null
        IF phone_number IS NULL THEN
            RAISE EXCEPTION 'No phone number available. Unable to send SMS.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--DENISA
create function boolean_ticket()
returns trigger
language plpgsql
as
    $$
    declare phone varchar;
    begin
        select phone_number as phone
            from profile
                where email = NEW.profile_email;
        if phone is null
        then NEW.wants_racetime_on_sms = true;
        end if;
        return new;
    end;
    $$;
create trigger insert_ticket
    before insert
    on ticket
    for each row
    execute function boolean_ticket();

--ANOTHER ONE
create function add_one(integer)
return integer
as
$$
    begin
    return $1 + 1;
    end;
$$
    language 'plpgsql';

--example
select page_count, add_one(page_count)
from book;

