from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from flask_jwt_extended import JWTManager, jwt_required, create_access_token
from flask_mail import Mail, Message
from sqlalchemy import Boolean, Column, Date, ForeignKey, Integer, String, Float, DateTime
import os
import random
import string
from datetime import datetime, timedelta


app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['DEBUG'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'var/buddyUp.db')
app.config['JWT_SECRET_KEY'] = 'super-secret'  # change this IRL
app.config['MAIL_SERVER'] = 'smtp.mailtrap.io'
app.config['MAIL_USERNAME'] = ''
app.config['MAIL_PASSWORD'] = ''
# app.config['MAIL_USERNAME'] = os.environ['MAIL_USERNAME']
# app.config['MAIL_PASSWORD'] = os.environ['MAIL_PASSWORD']

print(app.config)
db = SQLAlchemy(app)
ma = Marshmallow(app)
jwt = JWTManager(app)
mail = Mail(app)


@app.cli.command('db_create')
def db_create():
    db.create_all()
    print('Database created!')


@app.cli.command('db_drop')
def db_drop():
    db.drop_all()
    print('Database dropped!')


@app.cli.command('db_seed')
def db_seed():

    # List of common first and last names to randomly choose from
    first_names = ['John', 'Emma', 'Olivia', 'Liam', 'William', 'Sophia', 'Isabella', 'Mia', 'Ethan', 'Noah']
    last_names = ['Smith', 'Johnson', 'Brown', 'Taylor', 'Miller', 'Wilson', 'Moore', 'Anderson', 'Clark', 'Wright']
    cities = ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento', 'Fresno', 'Long Beach', 'Oakland', 'Bakersfield', 'Anaheim', 'Santa Ana']
    activities = ['Hiking', 'Movie Night', 'Game Night', 'Happy Hour', 'Picnic', 'Concert', 'Beach Day', 'Barbecue', 'Museum Visit', 'Karaoke Night', 'Wine Tasting', 'Food Tour', 'Art Show', 'Comedy Club', 'Craft Beer Tasting', 'Farmers Market', 'Book Club', 'Escape Room', 'Painting Class', 'Salsa Dancing']
    descriptions = ['Go on a scenic hike with friends and enjoy the outdoors.',
                'Get together with friends and watch a new movie release.',
                'Host a game night and challenge your friends to their favorite board games.',
                'Unwind after work with a few drinks and good company.',
                'Gather your friends and enjoy a casual picnic in the park.',
                'Attend a live music performance and soak in the energy of the crowd.',
                'Spend a relaxing day at the beach with your friends.',
                'Fire up the grill and host a barbecue in your backyard.',
                'Explore a new museum exhibit with friends and expand your cultural knowledge.',
                'Sing your heart out at a local karaoke bar with friends.',
                'Sample a variety of wines at a local vineyard or tasting room.',
                'Embark on a culinary adventure and sample local foods and drinks.',
                'View and appreciate art from local artists at a gallery or exhibition.',
                'Laugh out loud at a comedy show with friends and enjoy a night of humor.',
                'Taste a variety of craft beers at a local brewery or tasting room.',
                'Browse and shop for fresh produce and handmade goods at a farmers market.',
                'Read and discuss a book with fellow book lovers at a book club.',
                'Solve puzzles and challenges with friends in an escape room.',
                'Learn to paint and create your own masterpiece at a painting class.',
                'Learn to salsa dance with friends and enjoy a night of music and movement.']

    # List of common email domains to randomly choose from
    email_domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'icloud.com']

    # List of common password requirements
    password_chars = string.ascii_letters + string.digits
    password_length = 8


    # Generate a random date in the past between 18 and 80 years ago
    now = datetime.now()
    start_date = now - timedelta(days=365*80)
    end_date = now - timedelta(days=365*18)
    days_between_dates = (end_date - start_date).days
    random_num_days = random.randint(0, days_between_dates)
    random_date = start_date + timedelta(days=random_num_days)

    # Format the random date as a string in the format YYYY-MM-DD
    random_dob_str = random_date.strftime('%Y-%m-%d')

    print(random_dob_str)

    def generate_username(first_name):
        username = first_name.lower() + str(random.randint(100, 999))
        return username

    # Generate a random 10-digit mobile number
    def generate_mobile_number():
        return ''.join(str(random.randint(0, 9)) for _ in range(10))
    
    def generate_start_and_end_time():
        # Set the range of time for the activity (in hours)
        activity_time_range = random.choice([1,2,3,4,5])

        # Get the current time
        now = datetime.now()

        # Generate a random start time within the range of activity time
        start_time = now + timedelta(hours=random.randint(0, activity_time_range - 1))

        # Generate a random end time within the range of activity time after the start time
        end_time = start_time + timedelta(hours=random.randint(1, activity_time_range))

        return start_time, end_time

    # Keep generating a new mobile number until it is unique
    used_mobile_numbers = set()
    usernames = set()

    start_end_time_list_1 = [ ("2023-05-05 08:00:00", "2023-05-05 10:00:00"), ("2023-05-05 10:30:00", "2023-05-05 12:30:00"),("2023-05-05 13:00:00", "2023-05-05 15:30:00"), ("2023-05-05 15:30:00", "2023-05-05 17:30:00"), ("2023-05-05 18:00:00", "2023-05-05 20:00:00"),("2023-05-05 09:30:00", "2023-05-05 11:30:00"), ("2023-05-05 12:00:00", "2023-05-05 14:00:00"), ("2023-05-05 14:30:00", "2023-05-05 16:30:00"), ("2023-05-05 17:00:00", "2023-05-05 19:00:00"), ("2023-05-05 19:30:00", "2023-05-05 21:30:00")]
    start_end_time_list_2 = [("2023-05-09 09:00:00", "2023-05-09 11:00:00"),    ("2023-05-09 14:00:00", "2023-05-09 16:00:00"),    ("2023-05-10 10:00:00", "2023-05-10 12:00:00"),    ("2023-05-10 15:00:00", "2023-05-10 17:00:00"),    ("2023-05-11 11:00:00", "2023-05-11 13:00:00"),    ("2023-05-11 14:00:00", "2023-05-11 16:00:00"),    ("2023-05-12 09:00:00", "2023-05-12 11:00:00"),    ("2023-05-12 13:00:00", "2023-05-12 15:00:00"),    ("2023-05-13 11:00:00", "2023-05-13 13:00:00"),    ("2023-05-13 14:00:00", "2023-05-13 16:00:00")]
    start_end_time_list_3 = [    ("2023-05-09 08:00:00", "2023-05-09 10:00:00"),    ("2023-05-09 12:00:00", "2023-05-09 14:00:00"),    ("2023-05-10 11:00:00", "2023-05-10 13:00:00"),    ("2023-05-10 16:00:00", "2023-05-10 18:00:00"),    ("2023-05-11 10:00:00", "2023-05-11 12:00:00"),    ("2023-05-11 15:00:00", "2023-05-11 17:00:00"),    ("2023-05-12 10:00:00", "2023-05-12 12:00:00"),    ("2023-05-12 14:00:00", "2023-05-12 16:00:00"),    ("2023-05-13 08:00:00", "2023-05-13 10:00:00"),    ("2023-05-13 12:00:00", "2023-05-13 14:00:00")]
    start_end_time_list_4 = [    ("2023-05-05 09:00:00", "2023-05-05 11:00:00"),    ("2023-05-05 14:00:00", "2023-05-05 16:00:00"),    ("2023-05-05 18:00:00", "2023-05-05 20:00:00"),    ("2023-05-05 21:00:00", "2023-05-05 23:00:00"),    ("2023-05-05 11:00:00", "2023-05-05 13:00:00"),    ("2023-05-05 15:00:00", "2023-05-05 17:00:00"),    ("2023-05-05 08:00:00", "2023-05-05 10:00:00"),    ("2023-05-05 12:00:00", "2023-05-05 14:00:00"),    ("2023-05-05 16:00:00", "2023-05-05 18:00:00"),    ("2023-05-05 19:00:00", "2023-05-05 21:00:00")]
    start_end_time_list_5 = [    ("2023-05-06 09:00:00", "2023-05-06 11:00:00"),    ("2023-05-06 14:00:00", "2023-05-06 16:00:00"),    ("2023-05-06 18:00:00", "2023-05-06 20:00:00"),    ("2023-05-06 21:00:00", "2023-05-06 23:00:00"),    ("2023-05-06 11:00:00", "2023-05-06 13:00:00"),    ("2023-05-06 15:00:00", "2023-05-06 17:00:00"),    ("2023-05-06 08:00:00", "2023-05-06 10:00:00"),    ("2023-05-06 12:00:00", "2023-05-06 14:00:00"),    ("2023-05-06 16:00:00", "2023-05-06 18:00:00"),    ("2023-05-06 19:00:00", "2023-05-06 21:00:00")]





    # Create 100 user objects with random attributes
    for i in range(100):
        select_time_list_random = random.choice([start_end_time_list_1,start_end_time_list_2,start_end_time_list_3, start_end_time_list_4, start_end_time_list_5])
        select_time_list = select_time_list_random.copy()
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)
        email_prefix = first_name.lower() + last_name.lower() + str(i+1)
        email_domain = random.choice(email_domains)
        email = email_prefix + '@' + email_domain
        password = ''.join(random.choice(password_chars) for i in range(password_length))
        location = random.choice(cities)
        while True:
            mobile_number = generate_mobile_number()
            if mobile_number not in used_mobile_numbers:
                used_mobile_numbers.add(mobile_number)
                mobile = mobile_number
                break
        while True:
            username = generate_username(first_name)
            if username not in usernames:
                usernames.add(username)
                user_name = username
                break
        # Generate a random date in the past between 18 and 80 years ago
        now = datetime.now()
        start_date = now - timedelta(days=365*80)
        end_date = now - timedelta(days=365*18)
        
        days_between_dates = (end_date - start_date).days
        random_num_days = random.randint(0, days_between_dates)
        random_date = start_date + timedelta(days=random_num_days)

        # Format the random date as a string in the format YYYY-MM-DD
        random_dob_str = random_date.strftime('%Y-%m-%d')

        user = User(email=email, password=password)
        db.session.add(user)
        row = User.query.filter_by(email=email).first()
        gender = random.choice(['men','women'])
        interested_in = random.choice(['men','women'])
        profileUrl = f"https://randomuser.me/api/portraits/{gender}/{random.randint(10,99)}.jpg"
        account = Account(user_id=row.user_id,dob=random_dob_str,gender=gender,
                          interested=interested_in,address=location,
                          mobile=mobile,user_name=user_name,first_name=first_name, last_name=last_name,email=email,profileUrl=profileUrl)
        db.session.add(account)
        account_row = Account.query.filter_by(user_id=row.user_id).first()

        event_length = random.randint(0, 10)
        for j in range(event_length):
            select_pair = random.choice(select_time_list)
            select_time_list.remove(select_pair)
            location = random.choice(cities)
            index_for_activity = random.randrange(0,len(activities))
            activity = activities[index_for_activity]
            description = descriptions[index_for_activity]
            start_time, end_time = select_pair
            e_t = datetime.strptime(end_time, "%Y-%m-%d %H:%M:%S")
            s_t = datetime.strptime(start_time, "%Y-%m-%d %H:%M:%S")
            duration = (e_t - s_t).total_seconds() / 3600
            event = Event(account_id=account_row.account_id,activity=activity,starttime=start_time,
                      endtime=end_time,location=location,description=description,duration=round(duration,1))
            db.session.add(event)
        

    # test_user = User(first_name='Ayush',
    #                  last_name='Bhardwaj',
    #                  email='test@test.com',
    #                  password='P@ssw0rd')
    # test_user1 = User(first_name='Ashish',
    #                  last_name='B',
    #                  email='ashish@test.com',
    #                  password='P@ssw0rd')
    # test_user2 = User(first_name='Nikhil',
    #                  last_name='P',
    #                  email='nikhil@test.com',
    #                  password='P@ssw0rd')

    # db.session.add(test_user)
    # db.session.add(test_user1)
    # db.session.add(test_user2)
    db.session.commit()
    print('Database seeded!')


@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/not_found')
def not_found():
    return jsonify(message='That resource was not found'), 404


@app.route('/users', methods=['GET'])
def users():
    users_list = User.query.all()
    result = users_schema.dump(users_list)
    return jsonify(result)



@app.route('/register', methods=['POST'])
def register():
    email = request.form['email']
    test = User.query.filter_by(email=email).first()
    if test:
        return jsonify(message='That email already exists.'), 409
    else:
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        password = request.form['password']
        user = User(first_name=first_name, last_name=last_name, email=email, password=password)
        # fields = ('user_id','account_id', 'user_name', 'gender', 'dob', 'mobile', 'location', 'interested')
        db.session.add(user)
        row = User.query.filter_by(email=email).first()
        account = Account(user_id=row.user_id)
        db.session.add(account)
        db.session.commit()
        return jsonify(message="User created successfully."), 201


@app.route('/login', methods=['POST'])
def login():
    if request.is_json:
        email = request.json['email']
        password = request.json['password']
    else:
        email = request.form['email']
        password = request.form['password']

    test = User.query.filter_by(email=email, password=password).first()
    if test:
        access_token = create_access_token(identity=email)
        return jsonify(message="Login succeeded!", access_token=access_token, id = test.user_id)
    else:
        return jsonify(message="Bad email or password"), 401


@app.route('/retrieve_password/<string:email>', methods=['GET'])
def retrieve_password(email: str):
    user = User.query.filter_by(email=email).first()
    if user:
        print(user)
        msg = Message("your mate API password is " + user.password,
                      sender="ayush@csu.fullerton.edu",
                      recipients=[email])
        mail.send(msg)
        return jsonify(message="Password sent to " + email)
    else:
        return jsonify(message="That email doesn't exist"), 401

#Account API

@app.route('/all_accounts', methods=['GET'])
def accounts():
    accounts_list = Account.query.all()
    result = accounts_schema.dump(accounts_list)
    response = {}
    response['data'] = result
    return jsonify(response)

@app.route('/account_details/<int:account_id>', methods=["GET"])
def account_details(account_id: int):
    account = Account.query.filter_by(account_id=account_id).first()
    if account:
        result = account_schema.dump(account)
        return jsonify(result)
    else:
        return jsonify(message="That planet does not exist"), 404

@app.route('/update_account', methods=['PUT'])
# @jwt_required
def update_account():
    id = int(request.form['account_id'])
    account = Account.query.filter_by(account_id=id).first()
    if account:
        account.dob = request.form['dob']
        account.gender = request.form['gender']
        account.interested = request.form['interested']
        account.location = request.form['location']
        account.mobile = request.form['mobile']
        account.user_name = request.form['user_name']
        db.session.commit()
        return jsonify(message="You updated the profile"), 202
    else:
        return jsonify(message="The account does not exist"), 404


#Events API
@app.route('/events/<int:account_id>', methods=['GET'])
def events(account_id : int):
    events_list = Event.query.filter_by(account_id=account_id).all()
    result = events_schema.dump(events_list)
    return jsonify(result)


@app.route('/add_event/<int:account_id>', methods=['POST'])
# @jwt_required
def add_event(account_id: int):
        activity = request.form['activity']
        description = request.form['description']
        starttime = request.form['starttime']
        endtime = request.form['endtime']
        new_event = Event(account_id=account_id,
                          activity = activity,
                          description = description,
                          starttime = starttime,
                          endtime = endtime)

        db.session.add(new_event)
        db.session.commit()
        return jsonify(message="You added new event"), 201

@app.route('/update_event/<int:account_id>/<int:event_id>', methods=['PUT'])
# @jwt_required
def update_event(account_id: int, event_id : int):
    event_id = int(request.form['event_id'])
    event = Event.query.filter_by(account_id=account_id,event_id=event_id).first()
    if event:
        event.activity = request.form['activity']
        event.description = request.form['description']
        event.starttime = request.form['starttime']
        event.endtime = request.form['endtime']
        db.session.commit()
        return jsonify(message="You updated an event"), 202
    else:
        return jsonify(message="That event does not exist"), 404
    
# Chat API
# @app.route('/chats/<int:account_id>', methods=['GET'])
# def chats(account_id: int):
#     chats_list = Chat.query.filter_by(account_id=account_id).all()
#     result = chats_schema.dump(chats_list)
#     return jsonify(result)

# @app.route('/chats/<int:account_id>/<int:participant_id>', methods=['GET'])
# def chats(account_id: int, participant_id: int):
#     chats_list = Chat.query.filter_by(account_id=account_id).all()
#     result = chats_schema.dump(chats_list)
#     return jsonify(result)



# database models
class User(db.Model):
    __tablename__ = 'users'

    user_id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    password = Column(String)


class Account(db.Model):
    __tablename__ = 'accounts'
    user_id = Column(Integer, ForeignKey('users.user_id'))
    account_id = Column(Integer, primary_key=True)
    user_name = Column(String, unique=True)
    first_name = Column(String)
    last_name = Column(String)
    email = Column(String, unique=True)
    gender = Column(String)
    dob = Column(String)
    mobile = Column(String)
    address = Column(String)
    profileUrl = Column(String)
    # distance_preference = Column(String)
    # distance_preference_status = Column(Boolean)
    interested = Column(String)
    # age_preference = Column(String)
    # age_preference_status = Column(Boolean)
    # language = Column(String)
    # push_notification = Column(Boolean)

class Event(db.Model):
    __tablename__ = 'events'
    event_id = Column(Integer, primary_key=True)
    account_id = Column(Integer, ForeignKey('accounts.account_id'))
    activity = Column(String)
    description = Column(String)
    starttime = Column(String)
    endtime = Column(String)
    location = Column(String)
    duration = Column(Float)

class Chat(db.Model):
    __tablename__ = 'chats'
    chat_id = Column(Integer, primary_key=True)
    account_id = Column(Integer, ForeignKey('accounts.account_id'))
    content = Column(String)
    reciever_id = Column(String)
    sender_id = Column(String)
    sendtime = Column(String)

class UserSchema(ma.Schema):
    class Meta:
        fields = ('user_id', 'email', 'password')


class AccountSchema(ma.Schema):
    class Meta:
        fields = ('user_id','account_id', 'first_name', 'last_name', 'email', 'user_name', 'gender', 'dob', 'mobile', 'address', 'interested','profileUrl')


class EventSchema(ma.Schema):
    class Meta:
        fields = ('event_id','account_id', 'activity','description', 'starttime', 'endtime', 'location')

class ChatSchema(ma.Schema):
    class Meta:
        fields = ('chat_id','account_id', 'content', 'reciever_id', 'sender_id','sendtime')


user_schema = UserSchema()
users_schema = UserSchema(many=True)

account_schema = AccountSchema()
accounts_schema = AccountSchema(many=True)

event_schema = EventSchema()
events_schema = EventSchema(many=True)

chat_schema = ChatSchema()
chats_schema = ChatSchema(many=True)

