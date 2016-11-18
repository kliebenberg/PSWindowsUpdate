# PSWindowsUpdate

## WSUS Support
An additional switch has been added to use a WSUS server that has been configured via Group\Local Policy. This switch sets ServerSelection to 1 for 'ManagedServer'. See [ServerSelection enumeration](https://msdn.microsoft.com/en-us/library/windows/desktop/aa387280(v=vs.85).aspx) for more info. 

```c
typedef enum  { 
  ssDefault        = 0,
  ssManagedServer  = 1,
  ssWindowsUpdate  = 2,
  ssOthers         = 3
} ServerSelection;
```