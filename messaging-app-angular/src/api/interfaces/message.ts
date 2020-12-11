export interface Message {
  id: number;
  senderId: number;
  senderName: string;
  groupId: number;
  groupName: string;
  content: string;
  dateSent: string;
  isPhoto: boolean;
  url: string;
  publicId: string;
}
