String mId, mToken, mMail;

get auth => "?auth=$mToken";

void removeData() {
  mId = null;
  mToken = null;
  mMail = null;
}
