from flask import Flask, render_template, request, redirect, url_for, session
import os
import sqlite3 
import subprocess
from Registration import register_user, login_user
from RideManagement import save_ride, search_rides  

app = Flask(__name__)

# Set a secret key for session management (Change this to a secure, random string)
app.secret_key = 'your_secret_key_here'


def create_database():
    print("inside db")
    if not os.path.exists('user_data.db'):
        subprocess.run(['python', 'DBScript.py'])

@app.route('/')
def first_page():
    return render_template('welcome.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        firstname = request.form.get("First Name")
        lastname = request.form.get("Last Name")
        contactno = request.form.get("Contact Number")
        emailid = request.form.get("emailid")
        password = request.form.get("password")
        cnfpassword = request.form.get("confirm-password")

        if password != cnfpassword:
            return render_template('signup.html', message="Passwords do not match.")

        create_database()
        try:
            unique_mail_check = register_user(firstname, lastname, contactno, emailid, password)
            if unique_mail_check:    
                return render_template('signup.html', message="User with same email already exist")
            else:
                return redirect(url_for('login_form'))
        except sqlite3.IntegrityError:
            return render_template('signup.html', message="Email already exists.")

    return render_template('signup.html')

    

@app.route('/login', methods=['GET', 'POST'])
def login_form():
    if request.method == 'POST':
        email = request.form.get("emailid")
        password = request.form.get("password")
        login_result = login_user(email, password)

        if 'Welcome' in login_result:
            session['username'] = email  
            return redirect(url_for('home'))  
        else:
            return render_template('login.html', message="Invalid password, try again.")

    return render_template('login.html')
@app.route('/home')
def home():
    return render_template('home.html')  



@app.route('/logout')
def logout():
    session.pop('username', None)  
    return redirect(url_for('login_form'))

@app.route('/offer', methods=['GET', 'POST'])
def offer_ride():
    if 'username' not in session:
        return redirect(url_for('login_form'))  

    if request.method == 'POST':
        from_place = request.form.get("from")
        to_place = request.form.get("to")
        via = request.form.get("via")
        seats = request.form.get("seats")
        date = request.form.get("date")
        time = request.form.get("time")
        username=session['username']
        
        ride_giver_name= username  
        save_ride(ride_giver_name, from_place, to_place, via, seats, date, time)

        return render_template('offer.html', message="Ride offered successfully!", username=session['username'])

    return render_template('offer.html', username=session['username'])  

@app.route('/find', methods=['GET', 'POST'])
def find_rides():
    if 'username' not in session:
        return redirect(url_for('login_form'))  

    if request.method == 'POST':
        from_place = request.form.get("from")
        to_place = request.form.get("to")
        find_date = request.form.get("date")
        find_time = request.form.get("time")
        

        
        rides = search_rides(from_place, to_place, find_date, find_time)
        print(rides)
        return render_template('matchingride.html', rides=rides, username=session['username'])

    return render_template('find.html', username=session['username'])

@app.route('/profile')
def profile():
    if 'username' not in session:
        return redirect(url_for('login_form'))  

    return render_template('profile.html', username=session['username'])

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)