s/\(^\|:\)u00a2\(\s\|\$\|$\|:\)/\1u00a2-halfwidth\2/
s/\(^\|:\)u00a3\(\s\|\$\|$\|:\)/\1u00a3-halfwidth\2/
s/\(^\|:\)u00a8\(\s\|\$\|$\|:\)/\1u00a8-halfwidth\2/
s/\(^\|:\)u00ac\(\s\|\$\|$\|:\)/\1u00ac-halfwidth\2/
s/\(^\|:\)u00b0\(\s\|\$\|$\|:\)/\1u00b0-halfwidth\2/
s/\(^\|:\)u00b6\(\s\|\$\|$\|:\)/\1u00b0-halfwidth\2/

/^u00a2-halfwidth\s/i u00a2	99:0:0:0:0:200:200:uffe0
/^u00a3-halfwidth\s/i u00a3	99:0:0:0:0:200:200:uffe1
/^u00a7\s/c u00a7	99:0:0:0:0:200:200:u00a7-fullwidth
/^u00a8-halfwidth\s/i u00a8	99:0:0:0:0:200:200:u00a8-fullwidth
/^u00ac-halfwidth\s/i u00ac	99:0:0:0:0:200:200:uffe2
/^u00b0-halfwidth\s/i u00b0	99:0:0:0:0:200:200:u00b0-fullwidth
/^u00b1\s/c u00b1	99:0:0:0:0:200:200:u00b1-fullwidth
/^u00b6-halfwidth\s/i u00b6	99:0:0:0:0:200:200:u00b6-fullwidth
/^u00d7\s/c u00d7	99:0:0:0:0:200:200:u00d7-fullwidth
/^u00f7\s/c u00f7	99:0:0:0:0:200:200:u00f7-fullwidth

/^u019e\s/c u019e	99:0:0:0:0:200:200:u019e-fullwidth
/^u02f7\s/c u02f7	99:0:0:0:0:200:200:u02f7-fullwidth

s/\(^\|:\)u0391\(\s\|\$\|$\|:\)/\1u0391-halfwidth\2/
s/\(^\|:\)u0392\(\s\|\$\|$\|:\)/\1u0392-halfwidth\2/
s/\(^\|:\)u0393\(\s\|\$\|$\|:\)/\1u0393-halfwidth\2/
s/\(^\|:\)u0394\(\s\|\$\|$\|:\)/\1u0394-halfwidth\2/
s/\(^\|:\)u0395\(\s\|\$\|$\|:\)/\1u0395-halfwidth\2/
s/\(^\|:\)u0396\(\s\|\$\|$\|:\)/\1u0396-halfwidth\2/
s/\(^\|:\)u0397\(\s\|\$\|$\|:\)/\1u0397-halfwidth\2/
s/\(^\|:\)u0398\(\s\|\$\|$\|:\)/\1u0398-halfwidth\2/
s/\(^\|:\)u0399\(\s\|\$\|$\|:\)/\1u0399-halfwidth\2/
s/\(^\|:\)u039a\(\s\|\$\|$\|:\)/\1u039a-halfwidth\2/
s/\(^\|:\)u039b\(\s\|\$\|$\|:\)/\1u039b-halfwidth\2/
s/\(^\|:\)u039c\(\s\|\$\|$\|:\)/\1u039c-halfwidth\2/
s/\(^\|:\)u039d\(\s\|\$\|$\|:\)/\1u039d-halfwidth\2/
s/\(^\|:\)u039e\(\s\|\$\|$\|:\)/\1u039e-halfwidth\2/
s/\(^\|:\)u039f\(\s\|\$\|$\|:\)/\1u039f-halfwidth\2/
s/\(^\|:\)u03a0\(\s\|\$\|$\|:\)/\1u03a0-halfwidth\2/
s/\(^\|:\)u03a1\(\s\|\$\|$\|:\)/\1u03a1-halfwidth\2/
s/\(^\|:\)u03a3\(\s\|\$\|$\|:\)/\1u03a3-halfwidth\2/
s/\(^\|:\)u03a4\(\s\|\$\|$\|:\)/\1u03a4-halfwidth\2/
s/\(^\|:\)u03a5\(\s\|\$\|$\|:\)/\1u03a5-halfwidth\2/
s/\(^\|:\)u03a6\(\s\|\$\|$\|:\)/\1u03a6-halfwidth\2/
s/\(^\|:\)u03a7\(\s\|\$\|$\|:\)/\1u03a7-halfwidth\2/
s/\(^\|:\)u03a8\(\s\|\$\|$\|:\)/\1u03a8-halfwidth\2/
s/\(^\|:\)u03a9\(\s\|\$\|$\|:\)/\1u03a9-halfwidth\2/
s/\(^\|:\)u03b1\(\s\|\$\|$\|:\)/\1u03b1-halfwidth\2/
s/\(^\|:\)u03b2\(\s\|\$\|$\|:\)/\1u03b2-halfwidth\2/
s/\(^\|:\)u03b3\(\s\|\$\|$\|:\)/\1u03b3-halfwidth\2/
s/\(^\|:\)u03b4\(\s\|\$\|$\|:\)/\1u03b4-halfwidth\2/
s/\(^\|:\)u03b5\(\s\|\$\|$\|:\)/\1u03b5-halfwidth\2/
s/\(^\|:\)u03b6\(\s\|\$\|$\|:\)/\1u03b6-halfwidth\2/
s/\(^\|:\)u03b7\(\s\|\$\|$\|:\)/\1u03b7-halfwidth\2/
s/\(^\|:\)u03b8\(\s\|\$\|$\|:\)/\1u03b8-halfwidth\2/
s/\(^\|:\)u03b9\(\s\|\$\|$\|:\)/\1u03b9-halfwidth\2/
s/\(^\|:\)u03ba\(\s\|\$\|$\|:\)/\1u03ba-halfwidth\2/
s/\(^\|:\)u03bb\(\s\|\$\|$\|:\)/\1u03bb-halfwidth\2/
s/\(^\|:\)u03bc\(\s\|\$\|$\|:\)/\1u03bc-halfwidth\2/
s/\(^\|:\)u03bd\(\s\|\$\|$\|:\)/\1u03bd-halfwidth\2/
s/\(^\|:\)u03be\(\s\|\$\|$\|:\)/\1u03be-halfwidth\2/
s/\(^\|:\)u03bf\(\s\|\$\|$\|:\)/\1u03bf-halfwidth\2/
s/\(^\|:\)u03c0\(\s\|\$\|$\|:\)/\1u03c0-halfwidth\2/
s/\(^\|:\)u03c1\(\s\|\$\|$\|:\)/\1u03c1-halfwidth\2/
s/\(^\|:\)u03c3\(\s\|\$\|$\|:\)/\1u03c3-halfwidth\2/
s/\(^\|:\)u03c4\(\s\|\$\|$\|:\)/\1u03c4-halfwidth\2/
s/\(^\|:\)u03c5\(\s\|\$\|$\|:\)/\1u03c5-halfwidth\2/
s/\(^\|:\)u03c6\(\s\|\$\|$\|:\)/\1u03c6-halfwidth\2/
s/\(^\|:\)u03c7\(\s\|\$\|$\|:\)/\1u03c7-halfwidth\2/
s/\(^\|:\)u03c8\(\s\|\$\|$\|:\)/\1u03c8-halfwidth\2/
s/\(^\|:\)u03c9\(\s\|\$\|$\|:\)/\1u03c9-halfwidth\2/
s/\(^\|:\)u0401\(\s\|\$\|$\|:\)/\1u0401-halfwidth\2/
s/\(^\|:\)u0410\(\s\|\$\|$\|:\)/\1u0410-halfwidth\2/
s/\(^\|:\)u0411\(\s\|\$\|$\|:\)/\1u0411-halfwidth\2/
s/\(^\|:\)u0412\(\s\|\$\|$\|:\)/\1u0412-halfwidth\2/
s/\(^\|:\)u0413\(\s\|\$\|$\|:\)/\1u0413-halfwidth\2/
s/\(^\|:\)u0414\(\s\|\$\|$\|:\)/\1u0414-halfwidth\2/
s/\(^\|:\)u0415\(\s\|\$\|$\|:\)/\1u0415-halfwidth\2/
s/\(^\|:\)u0416\(\s\|\$\|$\|:\)/\1u0416-halfwidth\2/
s/\(^\|:\)u0417\(\s\|\$\|$\|:\)/\1u0417-halfwidth\2/
s/\(^\|:\)u0418\(\s\|\$\|$\|:\)/\1u0418-halfwidth\2/
s/\(^\|:\)u0419\(\s\|\$\|$\|:\)/\1u0419-halfwidth\2/
s/\(^\|:\)u041a\(\s\|\$\|$\|:\)/\1u041a-halfwidth\2/
s/\(^\|:\)u041b\(\s\|\$\|$\|:\)/\1u041b-halfwidth\2/
s/\(^\|:\)u041c\(\s\|\$\|$\|:\)/\1u041c-halfwidth\2/
s/\(^\|:\)u041d\(\s\|\$\|$\|:\)/\1u041d-halfwidth\2/
s/\(^\|:\)u041e\(\s\|\$\|$\|:\)/\1u041e-halfwidth\2/
s/\(^\|:\)u041f\(\s\|\$\|$\|:\)/\1u041f-halfwidth\2/
s/\(^\|:\)u0420\(\s\|\$\|$\|:\)/\1u0420-halfwidth\2/
s/\(^\|:\)u0421\(\s\|\$\|$\|:\)/\1u0421-halfwidth\2/
s/\(^\|:\)u0422\(\s\|\$\|$\|:\)/\1u0422-halfwidth\2/
s/\(^\|:\)u0423\(\s\|\$\|$\|:\)/\1u0423-halfwidth\2/
s/\(^\|:\)u0424\(\s\|\$\|$\|:\)/\1u0424-halfwidth\2/
s/\(^\|:\)u0425\(\s\|\$\|$\|:\)/\1u0425-halfwidth\2/
s/\(^\|:\)u0426\(\s\|\$\|$\|:\)/\1u0426-halfwidth\2/
s/\(^\|:\)u0427\(\s\|\$\|$\|:\)/\1u0427-halfwidth\2/
s/\(^\|:\)u0428\(\s\|\$\|$\|:\)/\1u0428-halfwidth\2/
s/\(^\|:\)u0429\(\s\|\$\|$\|:\)/\1u0429-halfwidth\2/
s/\(^\|:\)u042a\(\s\|\$\|$\|:\)/\1u042a-halfwidth\2/
s/\(^\|:\)u042b\(\s\|\$\|$\|:\)/\1u042b-halfwidth\2/
s/\(^\|:\)u042c\(\s\|\$\|$\|:\)/\1u042c-halfwidth\2/
s/\(^\|:\)u042d\(\s\|\$\|$\|:\)/\1u042d-halfwidth\2/
s/\(^\|:\)u042e\(\s\|\$\|$\|:\)/\1u042e-halfwidth\2/
s/\(^\|:\)u042f\(\s\|\$\|$\|:\)/\1u042f-halfwidth\2/
s/\(^\|:\)u0430\(\s\|\$\|$\|:\)/\1u0430-halfwidth\2/
s/\(^\|:\)u0431\(\s\|\$\|$\|:\)/\1u0431-halfwidth\2/
s/\(^\|:\)u0432\(\s\|\$\|$\|:\)/\1u0432-halfwidth\2/
s/\(^\|:\)u0433\(\s\|\$\|$\|:\)/\1u0433-halfwidth\2/
s/\(^\|:\)u0434\(\s\|\$\|$\|:\)/\1u0434-halfwidth\2/
s/\(^\|:\)u0435\(\s\|\$\|$\|:\)/\1u0435-halfwidth\2/
s/\(^\|:\)u0436\(\s\|\$\|$\|:\)/\1u0436-halfwidth\2/
s/\(^\|:\)u0437\(\s\|\$\|$\|:\)/\1u0437-halfwidth\2/
s/\(^\|:\)u0438\(\s\|\$\|$\|:\)/\1u0438-halfwidth\2/
s/\(^\|:\)u0439\(\s\|\$\|$\|:\)/\1u0439-halfwidth\2/
s/\(^\|:\)u043a\(\s\|\$\|$\|:\)/\1u043a-halfwidth\2/
s/\(^\|:\)u043b\(\s\|\$\|$\|:\)/\1u043b-halfwidth\2/
s/\(^\|:\)u043c\(\s\|\$\|$\|:\)/\1u043c-halfwidth\2/
s/\(^\|:\)u043d\(\s\|\$\|$\|:\)/\1u043d-halfwidth\2/
s/\(^\|:\)u043e\(\s\|\$\|$\|:\)/\1u043e-halfwidth\2/
s/\(^\|:\)u043f\(\s\|\$\|$\|:\)/\1u043f-halfwidth\2/
s/\(^\|:\)u0440\(\s\|\$\|$\|:\)/\1u0440-halfwidth\2/
s/\(^\|:\)u0441\(\s\|\$\|$\|:\)/\1u0441-halfwidth\2/
s/\(^\|:\)u0442\(\s\|\$\|$\|:\)/\1u0442-halfwidth\2/
s/\(^\|:\)u0443\(\s\|\$\|$\|:\)/\1u0443-halfwidth\2/
s/\(^\|:\)u0444\(\s\|\$\|$\|:\)/\1u0444-halfwidth\2/
s/\(^\|:\)u0445\(\s\|\$\|$\|:\)/\1u0445-halfwidth\2/
s/\(^\|:\)u0446\(\s\|\$\|$\|:\)/\1u0446-halfwidth\2/
s/\(^\|:\)u0447\(\s\|\$\|$\|:\)/\1u0447-halfwidth\2/
s/\(^\|:\)u0448\(\s\|\$\|$\|:\)/\1u0448-halfwidth\2/
s/\(^\|:\)u0449\(\s\|\$\|$\|:\)/\1u0449-halfwidth\2/
s/\(^\|:\)u044a\(\s\|\$\|$\|:\)/\1u044a-halfwidth\2/
s/\(^\|:\)u044b\(\s\|\$\|$\|:\)/\1u044b-halfwidth\2/
s/\(^\|:\)u044c\(\s\|\$\|$\|:\)/\1u044c-halfwidth\2/
s/\(^\|:\)u044d\(\s\|\$\|$\|:\)/\1u044d-halfwidth\2/
s/\(^\|:\)u044e\(\s\|\$\|$\|:\)/\1u044e-halfwidth\2/
s/\(^\|:\)u044f\(\s\|\$\|$\|:\)/\1u044f-halfwidth\2/
s/\(^\|:\)u0451\(\s\|\$\|$\|:\)/\1u0451-halfwidth\2/

/^u0391-halfwidth\s/i u0391	99:0:0:0:0:200:200:u0391-fullwidth
/^u0392-halfwidth\s/i u0392	99:0:0:0:0:200:200:u0392-fullwidth
/^u0393-halfwidth\s/i u0393	99:0:0:0:0:200:200:u0393-fullwidth
/^u0394-halfwidth\s/i u0394	99:0:0:0:0:200:200:u0394-fullwidth
/^u0395-halfwidth\s/i u0395	99:0:0:0:0:200:200:u0395-fullwidth
/^u0396-halfwidth\s/i u0396	99:0:0:0:0:200:200:u0396-fullwidth
/^u0397-halfwidth\s/i u0397	99:0:0:0:0:200:200:u0397-fullwidth
/^u0398-halfwidth\s/i u0398	99:0:0:0:0:200:200:u0398-fullwidth
/^u0399-halfwidth\s/i u0399	99:0:0:0:0:200:200:u0399-fullwidth
/^u039a-halfwidth\s/i u039a	99:0:0:0:0:200:200:u039a-fullwidth
/^u039b-halfwidth\s/i u039b	99:0:0:0:0:200:200:u039b-fullwidth
/^u039c-halfwidth\s/i u039c	99:0:0:0:0:200:200:u039c-fullwidth
/^u039d-halfwidth\s/i u039d	99:0:0:0:0:200:200:u039d-fullwidth
/^u039e-halfwidth\s/i u039e	99:0:0:0:0:200:200:u039e-fullwidth
/^u039f-halfwidth\s/i u039f	99:0:0:0:0:200:200:u039f-fullwidth
/^u03a0-halfwidth\s/i u03a0	99:0:0:0:0:200:200:u03a0-fullwidth
/^u03a1-halfwidth\s/i u03a1	99:0:0:0:0:200:200:u03a1-fullwidth
/^u03a3-halfwidth\s/i u03a3	99:0:0:0:0:200:200:u03a3-fullwidth
/^u03a4-halfwidth\s/i u03a4	99:0:0:0:0:200:200:u03a4-fullwidth
/^u03a5-halfwidth\s/i u03a5	99:0:0:0:0:200:200:u03a5-fullwidth
/^u03a6-halfwidth\s/i u03a6	99:0:0:0:0:200:200:u03a6-fullwidth
/^u03a7-halfwidth\s/i u03a7	99:0:0:0:0:200:200:u03a7-fullwidth
/^u03a8-halfwidth\s/i u03a8	99:0:0:0:0:200:200:u03a8-fullwidth
/^u03a9-halfwidth\s/i u03a9	99:0:0:0:0:200:200:u03a9-fullwidth
/^u03b1-halfwidth\s/i u03b1	99:0:0:0:0:200:200:u03b1-fullwidth
/^u03b2-halfwidth\s/i u03b2	99:0:0:0:0:200:200:u03b2-fullwidth
/^u03b3-halfwidth\s/i u03b3	99:0:0:0:0:200:200:u03b3-fullwidth
/^u03b4-halfwidth\s/i u03b4	99:0:0:0:0:200:200:u03b4-fullwidth
/^u03b5-halfwidth\s/i u03b5	99:0:0:0:0:200:200:u03b5-fullwidth
/^u03b6-halfwidth\s/i u03b6	99:0:0:0:0:200:200:u03b6-fullwidth
/^u03b7-halfwidth\s/i u03b7	99:0:0:0:0:200:200:u03b7-fullwidth
/^u03b8-halfwidth\s/i u03b8	99:0:0:0:0:200:200:u03b8-fullwidth
/^u03b9-halfwidth\s/i u03b9	99:0:0:0:0:200:200:u03b9-fullwidth
/^u03ba-halfwidth\s/i u03ba	99:0:0:0:0:200:200:u03ba-fullwidth
/^u03bb-halfwidth\s/i u03bb	99:0:0:0:0:200:200:u03bb-fullwidth
/^u03bc-halfwidth\s/i u03bc	99:0:0:0:0:200:200:u03bc-fullwidth
/^u03bd-halfwidth\s/i u03bd	99:0:0:0:0:200:200:u03bd-fullwidth
/^u03be-halfwidth\s/i u03be	99:0:0:0:0:200:200:u03be-fullwidth
/^u03bf-halfwidth\s/i u03bf	99:0:0:0:0:200:200:u03bf-fullwidth
/^u03c0-halfwidth\s/i u03c0	99:0:0:0:0:200:200:u03c0-fullwidth
/^u03c1-halfwidth\s/i u03c1	99:0:0:0:0:200:200:u03c1-fullwidth
/^u03c3-halfwidth\s/i u03c3	99:0:0:0:0:200:200:u03c3-fullwidth
/^u03c4-halfwidth\s/i u03c4	99:0:0:0:0:200:200:u03c4-fullwidth
/^u03c5-halfwidth\s/i u03c5	99:0:0:0:0:200:200:u03c5-fullwidth
/^u03c6-halfwidth\s/i u03c6	99:0:0:0:0:200:200:u03c6-fullwidth
/^u03c7-halfwidth\s/i u03c7	99:0:0:0:0:200:200:u03c7-fullwidth
/^u03c8-halfwidth\s/i u03c8	99:0:0:0:0:200:200:u03c8-fullwidth
/^u03c9-halfwidth\s/i u03c9	99:0:0:0:0:200:200:u03c9-fullwidth
/^u0401-halfwidth\s/i u0401	99:0:0:0:0:200:200:u0401-fullwidth
/^u0410-halfwidth\s/i u0410	99:0:0:0:0:200:200:u0410-fullwidth
/^u0411-halfwidth\s/i u0411	99:0:0:0:0:200:200:u0411-fullwidth
/^u0412-halfwidth\s/i u0412	99:0:0:0:0:200:200:u0412-fullwidth
/^u0413-halfwidth\s/i u0413	99:0:0:0:0:200:200:u0413-fullwidth
/^u0414-halfwidth\s/i u0414	99:0:0:0:0:200:200:u0414-fullwidth
/^u0415-halfwidth\s/i u0415	99:0:0:0:0:200:200:u0415-fullwidth
/^u0416-halfwidth\s/i u0416	99:0:0:0:0:200:200:u0416-fullwidth
/^u0417-halfwidth\s/i u0417	99:0:0:0:0:200:200:u0417-fullwidth
/^u0418-halfwidth\s/i u0418	99:0:0:0:0:200:200:u0418-fullwidth
/^u0419-halfwidth\s/i u0419	99:0:0:0:0:200:200:u0419-fullwidth
/^u041a-halfwidth\s/i u041a	99:0:0:0:0:200:200:u041a-fullwidth
/^u041b-halfwidth\s/i u041b	99:0:0:0:0:200:200:u041b-fullwidth
/^u041c-halfwidth\s/i u041c	99:0:0:0:0:200:200:u041c-fullwidth
/^u041d-halfwidth\s/i u041d	99:0:0:0:0:200:200:u041d-fullwidth
/^u041e-halfwidth\s/i u041e	99:0:0:0:0:200:200:u041e-fullwidth
/^u041f-halfwidth\s/i u041f	99:0:0:0:0:200:200:u041f-fullwidth
/^u0420-halfwidth\s/i u0420	99:0:0:0:0:200:200:u0420-fullwidth
/^u0421-halfwidth\s/i u0421	99:0:0:0:0:200:200:u0421-fullwidth
/^u0422-halfwidth\s/i u0422	99:0:0:0:0:200:200:u0422-fullwidth
/^u0423-halfwidth\s/i u0423	99:0:0:0:0:200:200:u0423-fullwidth
/^u0424-halfwidth\s/i u0424	99:0:0:0:0:200:200:u0424-fullwidth
/^u0425-halfwidth\s/i u0425	99:0:0:0:0:200:200:u0425-fullwidth
/^u0426-halfwidth\s/i u0426	99:0:0:0:0:200:200:u0426-fullwidth
/^u0427-halfwidth\s/i u0427	99:0:0:0:0:200:200:u0427-fullwidth
/^u0428-halfwidth\s/i u0428	99:0:0:0:0:200:200:u0428-fullwidth
/^u0429-halfwidth\s/i u0429	99:0:0:0:0:200:200:u0429-fullwidth
/^u042a-halfwidth\s/i u042a	99:0:0:0:0:200:200:u042a-fullwidth
/^u042b-halfwidth\s/i u042b	99:0:0:0:0:200:200:u042b-fullwidth
/^u042c-halfwidth\s/i u042c	99:0:0:0:0:200:200:u042c-fullwidth
/^u042d-halfwidth\s/i u042d	99:0:0:0:0:200:200:u042d-fullwidth
/^u042e-halfwidth\s/i u042e	99:0:0:0:0:200:200:u042e-fullwidth
/^u042f-halfwidth\s/i u042f	99:0:0:0:0:200:200:u042f-fullwidth
/^u0430-halfwidth\s/i u0430	99:0:0:0:0:200:200:u0430-fullwidth
/^u0431-halfwidth\s/i u0431	99:0:0:0:0:200:200:u0431-fullwidth
/^u0432-halfwidth\s/i u0432	99:0:0:0:0:200:200:u0432-fullwidth
/^u0433-halfwidth\s/i u0433	99:0:0:0:0:200:200:u0433-fullwidth
/^u0434-halfwidth\s/i u0434	99:0:0:0:0:200:200:u0434-fullwidth
/^u0435-halfwidth\s/i u0435	99:0:0:0:0:200:200:u0435-fullwidth
/^u0436-halfwidth\s/i u0436	99:0:0:0:0:200:200:u0436-fullwidth
/^u0437-halfwidth\s/i u0437	99:0:0:0:0:200:200:u0437-fullwidth
/^u0438-halfwidth\s/i u0438	99:0:0:0:0:200:200:u0438-fullwidth
/^u0439-halfwidth\s/i u0439	99:0:0:0:0:200:200:u0439-fullwidth
/^u043a-halfwidth\s/i u043a	99:0:0:0:0:200:200:u043a-fullwidth
/^u043b-halfwidth\s/i u043b	99:0:0:0:0:200:200:u043b-fullwidth
/^u043c-halfwidth\s/i u043c	99:0:0:0:0:200:200:u043c-fullwidth
/^u043d-halfwidth\s/i u043d	99:0:0:0:0:200:200:u043d-fullwidth
/^u043e-halfwidth\s/i u043e	99:0:0:0:0:200:200:u043e-fullwidth
/^u043f-halfwidth\s/i u043f	99:0:0:0:0:200:200:u043f-fullwidth
/^u0440-halfwidth\s/i u0440	99:0:0:0:0:200:200:u0440-fullwidth
/^u0441-halfwidth\s/i u0441	99:0:0:0:0:200:200:u0441-fullwidth
/^u0442-halfwidth\s/i u0442	99:0:0:0:0:200:200:u0442-fullwidth
/^u0443-halfwidth\s/i u0443	99:0:0:0:0:200:200:u0443-fullwidth
/^u0444-halfwidth\s/i u0444	99:0:0:0:0:200:200:u0444-fullwidth
/^u0445-halfwidth\s/i u0445	99:0:0:0:0:200:200:u0445-fullwidth
/^u0446-halfwidth\s/i u0446	99:0:0:0:0:200:200:u0446-fullwidth
/^u0447-halfwidth\s/i u0447	99:0:0:0:0:200:200:u0447-fullwidth
/^u0448-halfwidth\s/i u0448	99:0:0:0:0:200:200:u0448-fullwidth
/^u0449-halfwidth\s/i u0449	99:0:0:0:0:200:200:u0449-fullwidth
/^u044a-halfwidth\s/i u044a	99:0:0:0:0:200:200:u044a-fullwidth
/^u044b-halfwidth\s/i u044b	99:0:0:0:0:200:200:u044b-fullwidth
/^u044c-halfwidth\s/i u044c	99:0:0:0:0:200:200:u044c-fullwidth
/^u044d-halfwidth\s/i u044d	99:0:0:0:0:200:200:u044d-fullwidth
/^u044e-halfwidth\s/i u044e	99:0:0:0:0:200:200:u044e-fullwidth
/^u044f-halfwidth\s/i u044f	99:0:0:0:0:200:200:u044f-fullwidth
/^u0451-halfwidth\s/i u0451	99:0:0:0:0:200:200:u0451-fullwidth

/^u1e9e\s/c u1e9e	99:0:0:0:0:200:200:u1e9e-fullwidth

s/\(^\|:\)u2010\(\s\|\$\|$\|:\)/\1u2010-halfwidth\2/
s/\(^\|:\)u2016\(\s\|\$\|$\|:\)/\1u2016-halfwidth\2/
s/\(^\|:\)u2018\(\s\|\$\|$\|:\)/\1u2018-halfwidth\2/
s/\(^\|:\)u2019\(\s\|\$\|$\|:\)/\1u2019-halfwidth\2/
s/\(^\|:\)u201c\(\s\|\$\|$\|:\)/\1u201c-halfwidth\2/
s/\(^\|:\)u201d\(\s\|\$\|$\|:\)/\1u201d-halfwidth\2/
s/\(^\|:\)u2020\(\s\|\$\|$\|:\)/\1u2020-halfwidth\2/
s/\(^\|:\)u2021\(\s\|\$\|$\|:\)/\1u2021-halfwidth\2/
s/\(^\|:\)u2032\(\s\|\$\|$\|:\)/\1u2032-halfwidth\2/
s/\(^\|:\)u2033\(\s\|\$\|$\|:\)/\1u2033-halfwidth\2/
s/\(^\|:\)u2202\(\s\|\$\|$\|:\)/\1u2202-halfwidth\2/
s/\(^\|:\)u2207\(\s\|\$\|$\|:\)/\1u2207-halfwidth\2/

/^u2010-halfwidth\s/i u2010	99:0:0:0:0:200:200:u2010-fullwidth
/^u2014\s/c u2014	99:0:0:0:0:200:200:u2014-fullwidth
/^u2016-halfwidth\s/i u2016	99:0:0:0:0:200:200:u2016-fullwidth
/^u2018-halfwidth\s/i u2018	99:0:0:0:0:200:200:u2018-fullwidth
/^u2019-halfwidth\s/i u2019	99:0:0:0:0:200:200:u2019-fullwidth
/^u201c-halfwidth\s/i u201c	99:0:0:0:0:200:200:u201c-fullwidth
/^u201d-halfwidth\s/i u201d	99:0:0:0:0:200:200:u201d-fullwidth
/^u2020-halfwidth\s/i u2020	99:0:0:0:0:200:200:u2020-fullwidth
/^u2021-halfwidth\s/i u2021	99:0:0:0:0:200:200:u2021-fullwidth
/^u2025\s/c u2025	99:0:0:0:0:200:200:u2025-fullwidth
/^u2026\s/c u2026	99:0:0:0:0:200:200:u2026-fullwidth
/^u2032-halfwidth\s/i u2032	99:0:0:0:0:200:200:u2032-fullwidth
/^u2033-halfwidth\s/i u2033	99:0:0:0:0:200:200:u2033-fullwidth
/^u204b\s/c u204b	99:0:0:0:0:200:200:u204b-fullwidth
/^u210e\s/c u210e	99:0:0:0:0:200:200:u210e-fullwidth
/^u2135\s/c u2135	99:0:0:0:0:200:200:u2135-fullwidth
/^u2202-halfwidth\s/i u2202	99:0:0:0:0:200:200:u2202-fullwidth
/^u2207-halfwidth\s/i u2207	99:0:0:0:0:200:200:u2207-fullwidth
/^u2212\s/c u2212	99:0:0:0:0:200:200:u2212-fullwidth
/^u2213\s/c u2213	99:0:0:0:0:200:200:u2213-fullwidth
/^u222b\s/c u222b	99:0:0:0:0:200:200:u222b-fullwidth
/^u222e\s/c u222e	99:0:0:0:0:200:200:u222e-fullwidth
/^u2260\s/c u2260	99:0:0:0:0:200:200:u2260-fullwidth

/^u2500\s/c u2500	99:0:0:0:0:200:200:u2500-fullwidth
/^u2501\s/c u2501	99:0:0:0:0:200:200:u2501-fullwidth
/^u2502\s/c u2502	99:0:0:0:0:200:200:u2502-fullwidth
/^u2503\s/c u2503	99:0:0:0:0:200:200:u2503-fullwidth
/^u2504\s/c u2504	99:0:0:0:0:200:200:u2504-fullwidth
/^u2505\s/c u2505	99:0:0:0:0:200:200:u2505-fullwidth
/^u2506\s/c u2506	99:0:0:0:0:200:200:u2506-fullwidth
/^u2507\s/c u2507	99:0:0:0:0:200:200:u2507-fullwidth
/^u2508\s/c u2508	99:0:0:0:0:200:200:u2508-fullwidth
/^u2509\s/c u2509	99:0:0:0:0:200:200:u2509-fullwidth
/^u250a\s/c u250a	99:0:0:0:0:200:200:u250a-fullwidth
/^u250b\s/c u250b	99:0:0:0:0:200:200:u250b-fullwidth
/^u250c\s/c u250c	99:0:0:0:0:200:200:u250c-fullwidth
/^u250d\s/c u250d	99:0:0:0:0:200:200:u250d-fullwidth
/^u250e\s/c u250e	99:0:0:0:0:200:200:u250e-fullwidth
/^u250f\s/c u250f	99:0:0:0:0:200:200:u250f-fullwidth
/^u2510\s/c u2510	99:0:0:0:0:200:200:u2510-fullwidth
/^u2511\s/c u2511	99:0:0:0:0:200:200:u2511-fullwidth
/^u2512\s/c u2512	99:0:0:0:0:200:200:u2512-fullwidth
/^u2513\s/c u2513	99:0:0:0:0:200:200:u2513-fullwidth
/^u2514\s/c u2514	99:0:0:0:0:200:200:u2514-fullwidth
/^u2515\s/c u2515	99:0:0:0:0:200:200:u2515-fullwidth
/^u2516\s/c u2516	99:0:0:0:0:200:200:u2516-fullwidth
/^u2517\s/c u2517	99:0:0:0:0:200:200:u2517-fullwidth
/^u2518\s/c u2518	99:0:0:0:0:200:200:u2518-fullwidth
/^u2519\s/c u2519	99:0:0:0:0:200:200:u2519-fullwidth
/^u251a\s/c u251a	99:0:0:0:0:200:200:u251a-fullwidth
/^u251b\s/c u251b	99:0:0:0:0:200:200:u251b-fullwidth
/^u251c\s/c u251c	99:0:0:0:0:200:200:u251c-fullwidth
/^u251d\s/c u251d	99:0:0:0:0:200:200:u251d-fullwidth
/^u251e\s/c u251e	99:0:0:0:0:200:200:u251e-fullwidth
/^u251f\s/c u251f	99:0:0:0:0:200:200:u251f-fullwidth
/^u2520\s/c u2520	99:0:0:0:0:200:200:u2520-fullwidth
/^u2521\s/c u2521	99:0:0:0:0:200:200:u2521-fullwidth
/^u2522\s/c u2522	99:0:0:0:0:200:200:u2522-fullwidth
/^u2523\s/c u2523	99:0:0:0:0:200:200:u2523-fullwidth
/^u2524\s/c u2524	99:0:0:0:0:200:200:u2524-fullwidth
/^u2525\s/c u2525	99:0:0:0:0:200:200:u2525-fullwidth
/^u2526\s/c u2526	99:0:0:0:0:200:200:u2526-fullwidth
/^u2527\s/c u2527	99:0:0:0:0:200:200:u2527-fullwidth
/^u2528\s/c u2528	99:0:0:0:0:200:200:u2528-fullwidth
/^u2529\s/c u2529	99:0:0:0:0:200:200:u2529-fullwidth
/^u252a\s/c u252a	99:0:0:0:0:200:200:u252a-fullwidth
/^u252b\s/c u252b	99:0:0:0:0:200:200:u252b-fullwidth
/^u252c\s/c u252c	99:0:0:0:0:200:200:u252c-fullwidth
/^u252d\s/c u252d	99:0:0:0:0:200:200:u252d-fullwidth
/^u252e\s/c u252e	99:0:0:0:0:200:200:u252e-fullwidth
/^u252f\s/c u252f	99:0:0:0:0:200:200:u252f-fullwidth
/^u2530\s/c u2530	99:0:0:0:0:200:200:u2530-fullwidth
/^u2531\s/c u2531	99:0:0:0:0:200:200:u2531-fullwidth
/^u2532\s/c u2532	99:0:0:0:0:200:200:u2532-fullwidth
/^u2533\s/c u2533	99:0:0:0:0:200:200:u2533-fullwidth
/^u2534\s/c u2534	99:0:0:0:0:200:200:u2534-fullwidth
/^u2535\s/c u2535	99:0:0:0:0:200:200:u2535-fullwidth
/^u2536\s/c u2536	99:0:0:0:0:200:200:u2536-fullwidth
/^u2537\s/c u2537	99:0:0:0:0:200:200:u2537-fullwidth
/^u2538\s/c u2538	99:0:0:0:0:200:200:u2538-fullwidth
/^u2539\s/c u2539	99:0:0:0:0:200:200:u2539-fullwidth
/^u253a\s/c u253a	99:0:0:0:0:200:200:u253a-fullwidth
/^u253b\s/c u253b	99:0:0:0:0:200:200:u253b-fullwidth
/^u253c\s/c u253c	99:0:0:0:0:200:200:u253c-fullwidth
/^u253d\s/c u253d	99:0:0:0:0:200:200:u253d-fullwidth
/^u253e\s/c u253e	99:0:0:0:0:200:200:u253e-fullwidth
/^u253f\s/c u253f	99:0:0:0:0:200:200:u253f-fullwidth
/^u2540\s/c u2540	99:0:0:0:0:200:200:u2540-fullwidth
/^u2541\s/c u2541	99:0:0:0:0:200:200:u2541-fullwidth
/^u2542\s/c u2542	99:0:0:0:0:200:200:u2542-fullwidth
/^u2543\s/c u2543	99:0:0:0:0:200:200:u2543-fullwidth
/^u2544\s/c u2544	99:0:0:0:0:200:200:u2544-fullwidth
/^u2545\s/c u2545	99:0:0:0:0:200:200:u2545-fullwidth
/^u2546\s/c u2546	99:0:0:0:0:200:200:u2546-fullwidth
/^u2547\s/c u2547	99:0:0:0:0:200:200:u2547-fullwidth
/^u2548\s/c u2548	99:0:0:0:0:200:200:u2548-fullwidth
/^u2549\s/c u2549	99:0:0:0:0:200:200:u2549-fullwidth
/^u254a\s/c u254a	99:0:0:0:0:200:200:u254a-fullwidth
/^u254b\s/c u254b	99:0:0:0:0:200:200:u254b-fullwidth
/^u254c\s/c u254c	99:0:0:0:0:200:200:u254c-fullwidth
/^u254d\s/c u254d	99:0:0:0:0:200:200:u254d-fullwidth
/^u254e\s/c u254e	99:0:0:0:0:200:200:u254e-fullwidth
/^u254f\s/c u254f	99:0:0:0:0:200:200:u254f-fullwidth
/^u2550\s/c u2550	99:0:0:0:0:200:200:u2550-fullwidth
/^u2551\s/c u2551	99:0:0:0:0:200:200:u2551-fullwidth
/^u2552\s/c u2552	99:0:0:0:0:200:200:u2552-fullwidth
/^u2553\s/c u2553	99:0:0:0:0:200:200:u2553-fullwidth
/^u2554\s/c u2554	99:0:0:0:0:200:200:u2554-fullwidth
/^u2555\s/c u2555	99:0:0:0:0:200:200:u2555-fullwidth
/^u2556\s/c u2556	99:0:0:0:0:200:200:u2556-fullwidth
/^u2557\s/c u2557	99:0:0:0:0:200:200:u2557-fullwidth
/^u2558\s/c u2558	99:0:0:0:0:200:200:u2558-fullwidth
/^u2559\s/c u2559	99:0:0:0:0:200:200:u2559-fullwidth
/^u255a\s/c u255a	99:0:0:0:0:200:200:u255a-fullwidth
/^u255b\s/c u255b	99:0:0:0:0:200:200:u255b-fullwidth
/^u255c\s/c u255c	99:0:0:0:0:200:200:u255c-fullwidth
/^u255d\s/c u255d	99:0:0:0:0:200:200:u255d-fullwidth
/^u255e\s/c u255e	99:0:0:0:0:200:200:u255e-fullwidth
/^u255f\s/c u255f	99:0:0:0:0:200:200:u255f-fullwidth
/^u2560\s/c u2560	99:0:0:0:0:200:200:u2560-fullwidth
/^u2561\s/c u2561	99:0:0:0:0:200:200:u2561-fullwidth
/^u2562\s/c u2562	99:0:0:0:0:200:200:u2562-fullwidth
/^u2563\s/c u2563	99:0:0:0:0:200:200:u2563-fullwidth
/^u2564\s/c u2564	99:0:0:0:0:200:200:u2564-fullwidth
/^u2565\s/c u2565	99:0:0:0:0:200:200:u2565-fullwidth
/^u2566\s/c u2566	99:0:0:0:0:200:200:u2566-fullwidth
/^u2567\s/c u2567	99:0:0:0:0:200:200:u2567-fullwidth
/^u2568\s/c u2568	99:0:0:0:0:200:200:u2568-fullwidth
/^u2569\s/c u2569	99:0:0:0:0:200:200:u2569-fullwidth
/^u256a\s/c u256a	99:0:0:0:0:200:200:u256a-fullwidth
/^u256b\s/c u256b	99:0:0:0:0:200:200:u256b-fullwidth
/^u256c\s/c u256c	99:0:0:0:0:200:200:u256c-fullwidth
/^u256d\s/c u256d	99:0:0:0:0:200:200:u256d-fullwidth
/^u256e\s/c u256e	99:0:0:0:0:200:200:u256e-fullwidth
/^u256f\s/c u256f	99:0:0:0:0:200:200:u256f-fullwidth
/^u2570\s/c u2570	99:0:0:0:0:200:200:u2570-fullwidth
/^u2571\s/c u2571	99:0:0:0:0:200:200:u2571-fullwidth
/^u2572\s/c u2572	99:0:0:0:0:200:200:u2572-fullwidth
/^u2573\s/c u2573	99:0:0:0:0:200:200:u2573-fullwidth
/^u2574\s/c u2574	99:0:0:0:0:200:200:u2574-fullwidth
/^u2575\s/c u2575	99:0:0:0:0:200:200:u2575-fullwidth
/^u2576\s/c u2576	99:0:0:0:0:200:200:u2576-fullwidth
/^u2577\s/c u2577	99:0:0:0:0:200:200:u2577-fullwidth
/^u2578\s/c u2578	99:0:0:0:0:200:200:u2578-fullwidth
/^u2579\s/c u2579	99:0:0:0:0:200:200:u2579-fullwidth
/^u257a\s/c u257a	99:0:0:0:0:200:200:u257a-fullwidth
/^u257b\s/c u257b	99:0:0:0:0:200:200:u257b-fullwidth
/^u257c\s/c u257c	99:0:0:0:0:200:200:u257c-fullwidth
/^u257d\s/c u257d	99:0:0:0:0:200:200:u257d-fullwidth
/^u257e\s/c u257e	99:0:0:0:0:200:200:u257e-fullwidth
/^u257f\s/c u257f	99:0:0:0:0:200:200:u257f-fullwidth
/^u2591\s/c u2591	99:0:0:0:0:200:200:u2591-fullwidth
/^u2592\s/c u2592	99:0:0:0:0:200:200:u2592-fullwidth
/^u2593\s/c u2593	99:0:0:0:0:200:200:u2593-fullwidth

s/\(^\|:\)u266d\(\s\|\$\|$\|:\)/\1u266d-halfwidth\2/
s/\(^\|:\)u266f\(\s\|\$\|$\|:\)/\1u266f-halfwidth\2/

/^u266d-halfwidth\s/i u266d	99:0:0:0:0:200:200:u266d-fullwidth
/^u266f-halfwidth\s/i u266f	99:0:0:0:0:200:200:u266f-fullwidth

/^ua668\s/c ua668	99:0:0:0:0:200:200:ua668-fullwidth

s/\(^\|:\)uff09\(\s\|\$\|$\|:\)/\1uff09-halfwidth\2/
s/\(^\|:\)uff3d\(\s\|\$\|$\|:\)/\1uff3d-halfwidth\2/
s/\(^\|:\)uff5d\(\s\|\$\|$\|:\)/\1uff5d-halfwidth\2/

/^uff09-halfwidth\s/i uff09	99:0:0:0:0:200:200:uff09-fullwidth
/^uff3d-halfwidth\s/i uff3d	99:0:0:0:0:200:200:uff3d-fullwidth
/^uff5d-halfwidth\s/i uff5d	99:0:0:0:0:200:200:uff5d-fullwidth
