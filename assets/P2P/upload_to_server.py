import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage

# Initialize Firebase
cred = credentials.Certificate('path/to/your-firebase-adminsdk-key.json')
firebase_admin.initialize_app(cred, {
    'storageBucket': 'your-project-id.appspot.com'
})

# Upload P2P_pro.csv to Firebase Storage
def upload_to_firebase_storage():
    bucket = storage.bucket()
    blob = bucket.blob('P2P_pro.csv')
    blob.upload_from_filename('P2P_pro.csv')
    print('P2P_pro.csv uploaded to Firebase Storage')

upload_to_firebase_storage()
