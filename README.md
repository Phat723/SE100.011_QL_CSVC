![AssetManagement](https://github.com/user-attachments/assets/82896ebd-0f67-4020-a1a6-2b7c7ea28efe)

# Asset Management

<table>
<tr>
<td>
  An application for managing physical assets within the university, including device management, inventory tracking, maintenance scheduling, usage history, and feedback for repairs if damaged. The app features two roles: students/teachers and admins.
</td>
</tr>
</table>

## Features

| Feature | Description |
| --- | --- |
| 🔐 **Register, Login, Forgot Password** | User authentication functionality. |
| 📊 **Asset Tracking** | Track the location and status of assets in real-time. |
| 🛠️ **Maintenance Scheduling** | Schedule and manage maintenance tasks for assets. |
| 📋 **Usage History** | View the usage history of assets. |
| 📝 **Feedback for Repairs** | Submit and manage feedback for asset repairs. |
| 📁 **Inventory Management** | Manage the inventory of assets, including adding, updating, and removing items. |
| 👥 **Role Management** | Manage user roles and permissions. |
| 🏢 **Admin Dashboard** | Admins can view statistics and manage assets, users, and maintenance tasks. |

### Main Functions in the User Interface
- 🔐 **Register, Login**: User authentication.
- 📋 **View Assets**: View the list of available assets.
- 🛠️ **Request Maintenance**: Submit maintenance requests.
- 📊 **Track Asset Usage**: Track the usage history of assets.
- 📝 **Provide Feedback**: Submit feedback for asset repairs.

### Main Functions in the Admin Interface
- 🔐 **Login**: Authenticate as an admin.
- 📁 **Manage Inventory**: Add, update, and remove assets.
- 📅 **Schedule Maintenance**: Organize and manage maintenance tasks.
- 📊 **View Statistics**: View usage statistics and asset status.
- 👥 **Manage Users**: Administer user accounts and roles.
- 📝 **Handle Feedback**: Manage feedback and repair requests.

## Installation

### Prerequisites
- Flutter SDK
- Dart SDK
- Firebase account with Firestore, Authentication, and Storage enabled

### Steps

1. **Clone the Repository**
    ```bash
    git clone https://github.com/Phat723/SE100.011_QL_CSVC
    cd SE100.011_QL_CSVC
    ```

2. **Install Dependencies**
    ```bash
    flutter pub get
    ```

3. **Set Up Firebase**
    - Create a Firebase project and enable Firestore, Authentication, and Storage.
    - Download the `google-services.json` file and place it in the `android/app` directory.

4. **Run the Application**
    ```bash
    flutter run
    ```

### Additional Tips
- For detailed instructions on setting up Flutter and Dart, refer to the [Flutter documentation](https://flutter.dev/docs/get-started/install).
- For Firebase setup, refer to the [Firebase documentation](https://firebase.google.com/docs).

## Usage

- **Register**: Create a new account or log in with an existing account.
- **View Assets**: Browse the list of assets available.
- **Request Maintenance**: Submit maintenance requests for assets.
- **Track Usage**: Monitor the usage history of assets.
- **Provide Feedback**: Submit feedback for repairs.

## Technologies Used 💻

- **Dart**
- **Flutter**: For building the mobile application.
- **Firebase**: For authentication, Firestore database, and storage.
- **Provider**: For state management.

## Screenshots 📸

# Let's create the markdown content with the given structure in English and in table format, filling in the provided URLs

markdown_content = """
## Screenshots 📸

### Home and User Interface
<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/cdde9b71-4460-4bd2-b26e-2bcaddf17030" width="300"/>
      <p>Home Screen for Lecturers & Students</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/248316aa-e7f9-4e52-a4f0-c0c0c107fc90" width="300"/>
      <p>Home Screen for Administrators & Technicians</p>
    </td>
  </tr>
</table>

### Device and Category Management
<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/7c445a3f-0132-4fa3-b2dc-93a7c60f5cc0" width="300"/>
      <p>Device Management Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/30843f07-0e97-4fe8-b1c8-c652a755447e" width="300"/>
      <p>Device Type Management Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/d312577b-ccf2-409c-866f-3e15aca33752" width="300"/>
      <p>Device Category Management Screen</p>
    </td>
  </tr>
</table>

### Reports and Evaluations
<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/cddc2ffb-a20c-40d2-9683-ddff8c4b31df" width="300"/>
      <p>Create Report Form Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/8f94d9c8-b67a-4bec-87b8-382f504e6ba7" width="300"/>
      <p>Fault Management Screen</p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/aa43b84b-0898-493e-b1f3-d9f38aa1a9a8" width="300"/>
      <p>Fault Detail Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/a7a1baad-c035-43bd-8fdc-5c1c7d3dd7f1" width="300"/>
      <p>Evaluation Management Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/985c9272-4bd8-477f-8c8b-ad4abeb11df3" width="300"/>
      <p>Create Evaluation Form Screen</p>
    </td>
  </tr>
</table>

### Borrow and Return Management
<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/19bec8fe-608e-4bf8-8cbe-4c8ccc642465" width="300"/>
      <p>Create Borrow and Return Form Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/6d99b4f3-4efa-4110-b7ca-f8c4f56e0c67" width="300"/>
      <p>Borrow and Return Form Management Screen</p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/99f463f1-a728-4cdd-a331-90fe6abcac9d" width="300"/>
      <p>Borrow and Return Form Detail Screen (Returned Status)</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/9e2c834d-1f11-4f0f-bbba-8df3fdae7a36" width="300"/>
      <p>Borrow and Return Form Detail Screen (Not Returned Status)</p>
    </td>
  </tr>
</table>

### Room and User Management
<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/08b51aa0-79c6-4cd2-a5b5-35799ce4f332" width="300"/>
      <p>Room Management Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/679ccd5a-b913-43d3-8279-3be6880defd5" width="300"/>
      <p>Violation Category Management Screen</p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/5f66f9ec-a5b8-4bd1-81a0-87d40d1f6d69" width="300"/>
      <p>User Management Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/04a529f6-e754-42cb-bf94-5c6986a039e5" width="300"/>
      <p>Add User Screen</p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/bb9c5e6e-f54a-47c5-8342-21050ec277c4" width="300"/>
      <p>Update User Information Screen</p>
    </td>
  </tr>
</table>

### Import, Export, and Statistics Management
<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/4ec718fb-e00a-4655-894e-4234823bbdc8" width="300"/>
      <p>Import and Export Management Screen</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/0fea2733-6517-495e-aee8-40eed044702b" width="300"/>
      <p>Create Import Form Screen</p>
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/15794045-f20d-4c42-9043-57db050d6f1b" width="300"/>
      <p>Statistics Screen</p>
    </td>
  </tr>
</table>

## Contributing 🤝

Want to contribute? Great!

To fix a bug or enhance an existing module, follow these steps:

- Fork the repo
- Create a new branch (`git checkout -b improve-feature`)
- Make the appropriate changes in the files
- Add changes to reflect the changes made
- Commit your changes (`git commit -am 'Improve feature'`)
- Push to the branch (`git push origin improve-feature`)
- Create a Pull Request

## Bug / Feature Request 🐛✨

If you encounter a bug or have a feature request, please open an issue by sending an email to 2409huynhphat@gmail.com. Kindly provide details of your query and the expected result in the email.

## To-do 📝

- Add new consultation features.
- Improve user interface and experience.
- Enhance real-time communication capabilities.
- Optimize performance and stability.

## Team 👥

**Development Team**
- [Tran Tien Phat](https://github.com/Phat7203)
- [Huynh Tien Phat](https://github.com/phathuynh24)
- [Nguyen Truong Bao Duy](https://github.com/bduy1011)

